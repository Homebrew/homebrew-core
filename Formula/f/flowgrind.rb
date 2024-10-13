class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://flowgrind.github.io"
  url "https://github.com/flowgrind/flowgrind/releases/download/flowgrind-0.8.2/flowgrind-0.8.2.tar.bz2"
  sha256 "432c4d15cb62d5d8d0b3509034bfb42380a02e3f0b75d16b7619a1ede07ac4f1"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/flowgrind[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7d7a2e643709a80e87d6585e6d96af3c50ba5d310a20cb7f9ca902db989e2115"
    sha256 cellar: :any,                 arm64_sonoma:   "25f3197b68720e0e5858a73c2fb8dd78b576a1f153cb2f383f06179bd637a17e"
    sha256 cellar: :any,                 arm64_ventura:  "c2fa42177d8ca42b47f974a821c1359b2ccb88b0ef286733974fddf35e5e5e83"
    sha256 cellar: :any,                 arm64_monterey: "677e2405fd0fd400387c26291671a4324e29885c14176eed3586d019edd33004"
    sha256 cellar: :any,                 sonoma:         "d645d6c2adbec394337e39eb92abd2de76255617cce022b8323737184d37bce8"
    sha256 cellar: :any,                 ventura:        "823a2b3a36d1c8e0b3b3781cdda8ddf3d014ac8f500e9e869cfaa72aa3957370"
    sha256 cellar: :any,                 monterey:       "c369b92e94e78c795892c5bfb5cbce8c548cd5b2e5bbafdef6576e50e7315846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f8ec4303d62ad6711cebe7f7af64499c0ee3c8cea09e98870a5a6b8f48b4512"
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
    system bin/"flowgrind", "--version"
  end
end
