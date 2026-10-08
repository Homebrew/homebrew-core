class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.4/omniORB-4.3.4.tar.bz2"
  sha256 "79720d415d23cd8da99287a4ef4da0aa1bd34d3e4c7b1530715600adc5ed3dc3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82b7a30ae2b47146013a79691f713034c3f94b042689228d8487eda5fa3d8c7b"
    sha256 cellar: :any, arm64_tahoe:       "536d279eea55b93c6c8fa314d4f954245f9b900ac021a1f25a8ec2784f746f6b"
    sha256 cellar: :any, arm64_sequoia:     "4a0b96d64f16f919f9e18a56c7de205d3bbb4067802d70f2c0b35bf4ba8cbd71"
    sha256 cellar: :any, arm64_linux:       "fd187ce56c0eedb5dba72b79f9372ad6705254d759d14a6e76aaf4da679f3a77"
    sha256 cellar: :any, x86_64_linux:      "d17e0ae63583d347b1ec6be6536a436e920be2ee35818dfbbc52d8a2f720f9cb"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "python@3.14"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.4/omniORBpy-4.3.4.tar.bz2"
    sha256 "a709c3c77b9c6b08616e1c9e12a5a9b9d5ccc1f2dcf6f647f205018d77f819a7"

    livecheck do
      formula :parent
    end
  end

  # OpenSSL 4 support: https://sourceforge.net/p/omniorb/svn/6818/
  patch do
    file "Patches/omniorb/r6818.diff"
    type :backport
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    # Help old config scripts identify arm64 linux
    build_arg = []
    build_arg << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    ENV["PYTHON"] = python3
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = build_arg + ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *build_arg, *std_configure_args
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system bin/"omniidl", "-h"
    system bin/"omniidl", "-bcxx", "-u"
    system bin/"omniidl", "-bpython", "-u"
  end
end
