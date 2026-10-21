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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2f295a5b5815b86ad2e9c61fabe16bf0b7cec0216dab957c377054bed0a2f12d"
    sha256 cellar: :any, arm64_tahoe:       "ce64157802869aae85e73fe2cd9ea5518b845762eeaa64fa714a085d3112ad4c"
    sha256 cellar: :any, arm64_sequoia:     "bd2c60e99cb87a30a3512ec0752264695994848b6f52816f05ce6ca7580cd99f"
    sha256 cellar: :any, arm64_linux:       "d8c353d71b184c88feb2a65276664bca66dc76505a4d3baadd5212968f68aa6b"
    sha256 cellar: :any, x86_64_linux:      "2fa39f3e59ea67986bf78b2fb3c81b57c082eeb02e2fe7b52aa0ef58e646618f"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "python@3.15"
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
