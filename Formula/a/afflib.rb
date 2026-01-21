class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.22.tar.gz"
  sha256 "67481fc520ff927bf61aea0bf2d660feb73e24cc329335bebb064f8f12115dcb"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "db3b39ef1335b3f8a8285a7aa4fdecd8f7dc720719f1a4900aeae3b32a80414f"
    sha256 cellar: :any,                 arm64_sequoia: "efdb247c3914a7f915a611100161c86380bba976856078094f2b80acfa7d9c12"
    sha256 cellar: :any,                 arm64_sonoma:  "488454a73b94dd3e858bd582ff0aa72ceae15fceb51f54192b96f142ff7af4ce"
    sha256 cellar: :any,                 sonoma:        "9638dd07d37bfc2ecce341bf7360e7a0681e529e89f991d580b31c2e67abfbf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df198c6d6c4ca05dca7821410d5ee80ad7618b3d50988c1ad62603a8b9c604ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e81fadf3c44eae7e1354f6239ec86e6c9ee341382f9a1b6ccd17c5ea095daa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    which("python3.14")
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-fuse",
                          "--disable-python",
                          "--disable-silent-rules",
                          "--enable-s3",
                          *std_configure_args
    system "make", "install"

    # We install Python bindings with pip rather than `./configure --enable-python` to avoid
    # managing Setuptools dependency and modifying Makefile to work around our sysconfig patch.
    # As a side effect, we need to imitate the Makefile and provide paths to headers/libraries.
    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./pyaff"
  end

  test do
    system bin/"affcat", "-v"

    system python3, "-c", "import pyaff"
  end
end
