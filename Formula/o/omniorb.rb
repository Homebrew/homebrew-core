class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.5/omniORB-4.3.5.tar.bz2"
  sha256 "d57c5ec43030b31eeb620b4c8e47d62bf08eab4945dbeab0e094f10c8447bf93"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f512703e96c09b0ae7625247f3de3fbb811879cb6fc558349733e96f67e9b3c2"
    sha256 cellar: :any, arm64_tahoe:       "7278bdfb6df53e89c83a3ff17beb9e1a0b050acf61385094d78126eefea129d8"
    sha256 cellar: :any, arm64_sequoia:     "1c740fc7f6c8909049c716f4df8eeddf1fe0128e978281d8625992c907f41d72"
    sha256 cellar: :any, arm64_linux:       "3b583aaeecd7a724b030711030f3c02667d513a693b1e321e879687acaf50ea5"
    sha256 cellar: :any, x86_64_linux:      "f06427c8ac5593771f2e95479301a97b0d0571f768b0a097f4faaed8a27bab29"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.5/omniORBpy-4.3.5.tar.bz2"
    sha256 "7ad8138c471b45132dc1bcd5b1b429b5fe07eefe9e8579558f1b3606bdda4172"

    livecheck do
      formula :parent
    end
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
