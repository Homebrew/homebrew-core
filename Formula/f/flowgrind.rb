class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "048fca783fbf50d8a1bb73d9724edb37f83ecc82cae12dbb952d1b12c6f52d39"
    sha256 cellar: :any, arm64_tahoe:       "4b48fbd91d33f54b410c4449281b3517bedf8a42174cbd0351209e84443751e2"
    sha256 cellar: :any, arm64_sequoia:     "ba20919ba3b0427735800935ccf724f606c00aca71c5d4d1a04b36d532702ccd"
    sha256 cellar: :any, arm64_sonoma:      "7ad19fb73c9ccbaec00c142d276d4e142c7a6678076a7d421f556d608aadc70f"
    sha256 cellar: :any, arm64_linux:       "f582fd23857e8add6ed2bcae767f7fe48c748af41f41f4a22b16a757f05caca8"
    sha256 cellar: :any, x86_64_linux:      "f56a800f9c2db032bf1cb714bcdd91d15761c4c744542cc8709ad5385995f100"
  end

  head do
    url "https://github.com/flowgrind/flowgrind.git", branch: "next"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"flowgrind", "--version"
  end
end
