class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f60d8edcde8a31eeafca3c30b0b1af02ce4a769166d751af254b313e3543bd2a"
    sha256 cellar: :any,                 arm64_ventura:  "82a2b71ee222c44ffe3f34d8732e6feb29b8ccb4261551c64ee74705bcb4ae5a"
    sha256 cellar: :any,                 arm64_monterey: "7a6a9d6cf73f3654f250518d52970c29d71d95480d17d85ae6f3b605e3ed9cd8"
    sha256 cellar: :any,                 arm64_big_sur:  "79be377bc6cfdc96c5f8bb42d97b91b51e81818894e68151496344b21515bce9"
    sha256 cellar: :any,                 sonoma:         "571c9241cf37667375cf5ea4b58daf92998635567f7a1a1754ffabe3e9415ed9"
    sha256 cellar: :any,                 ventura:        "bc919ff7842921cc2def6e3e755f383d847f0632355b14ecfa1bf20e46652a7a"
    sha256 cellar: :any,                 monterey:       "56cb3352c2793c2e4b74983de804a3d5ceed6fd9ab177c6e2f05a8856e07eb2d"
    sha256 cellar: :any,                 big_sur:        "148b960d7dea68adf8e076e53af487d83184fd2e71bc225cefb01f253ae282a3"
    sha256 cellar: :any,                 catalina:       "7c70ce687e46d8445f2e8c440924bdc2f54f8557ec073eaa605b598871b6b1f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46119269a79cc4b4432ce84f5fe06c104a3617c59f8cd026a19666d01ed4f36"
  end

  head do
    url "https://github.com/flowgrind/flowgrind.git", branch: "next"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  uses_from_macos "libpcap"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
