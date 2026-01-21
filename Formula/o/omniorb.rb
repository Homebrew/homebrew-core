class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.4/omniORB-4.3.4.tar.bz2"
  sha256 "79720d415d23cd8da99287a4ef4da0aa1bd34d3e4c7b1530715600adc5ed3dc3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1d18197b8e60eb0d7c301cedf714d2f77371a84767060df364e0939b6623d13"
    sha256 cellar: :any,                 arm64_sequoia: "26608b9e21b3bd279db67b11721e8b6db62b0f635e4aa4c136025e3ec85939b8"
    sha256 cellar: :any,                 arm64_sonoma:  "e7456a95b773cdbbb5911f76b7dbd2795dbe09979d704589a2c9ab7d0ee5209e"
    sha256 cellar: :any,                 sonoma:        "f82a0ddf7c8ecdc548722f7189f3bd22740cac3730717c57f3defb39f34ba4e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8cd5089645a78552c75ed40807748947caabf2a8b21c748a2551f531b520db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83475901471cdf6d650972b34703694938352ae993900762f70f246427b534cb"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zstd"

  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.4/omniORBpy-4.3.4.tar.bz2"
    sha256 "a709c3c77b9c6b08616e1c9e12a5a9b9d5ccc1f2dcf6f647f205018d77f819a7"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    # Help old config scripts identify arm64 linux
    build_arg = []
    build_arg << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    ENV["PYTHON"] = python3 = which("python3.14")
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
