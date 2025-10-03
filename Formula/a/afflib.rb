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
    sha256 cellar: :any,                 arm64_tahoe:   "196c9cf17edbb798e24c511ae565f3b74d201d653a48246d22533e9e55be6337"
    sha256 cellar: :any,                 arm64_sequoia: "b421ba045fb02e767029266042a2ef5cb78d727e51aa7d4778f740702c1799dc"
    sha256 cellar: :any,                 arm64_sonoma:  "ab72e2df66d54b60282c0cd72622d0b87a040c28cc57364066bc2983cf4f535c"
    sha256 cellar: :any,                 arm64_ventura: "a1c49c3b08d528875759b515107b347e349ffc11da766c6e5f582c5bf84bee46"
    sha256 cellar: :any,                 sonoma:        "81a1a9e643a0ea333a235e64a02afda8c2a3a9cbc15cdd9ce267c5751812623c"
    sha256 cellar: :any,                 ventura:       "14cfff06d69dc7b89260cf2522d8b084894f0584b68470ba5754130a642f48e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87c55f7acca8cf3a536c46fef31a35f3fad0b8238dfe73dae42a0c2c243d03c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30c8666fe681513980e6e8633483f84bd03cdb9203ffb13a0d2f3eb68596c954"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    which("python3.13")
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
