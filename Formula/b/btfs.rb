class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v2.24.tar.gz"
  sha256 "d71ddefe3c572e05362542a0d9fd0240d8d4e1578ace55a8b3245176e7fd8935"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "741d3c7890097ee5b9e337e0cfd18e8b0c9d221eff0512c3ee9dad59e9052c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c13f8e1ccf19a55a3bfe37a185a7f58d79ec7a2a69e318e662434b917c17b5d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/johang/btfs/issues/92
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    ENV.cxx11
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"btfs", "--help"
  end
end
