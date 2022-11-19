class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.33.tar.gz"
  sha256 "f48b2547313ffd1799c58c6a170175176131bbd42bc847b5650784eaf6d914b3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a1cc6c30584e795685e8498f07d098e7d74bfbec6801f20740c444f370a7cdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad044da8f2320589df7222858fa2e5373f19352a6e013ae7578b94ceae2daaeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3501b18fef99ff01487a05834b769d17b74bd107b91f5ef62cd14a3f8da81bd"
    sha256 cellar: :any_skip_relocation, ventura:        "822b5d0009d642e86ef6a01e78f36a5679db304ffd14ba50d0b3c8a4b4361983"
    sha256 cellar: :any_skip_relocation, monterey:       "c03af8fcce9c03638c6adeb76465edd30fd355ba214a0ccd57bc74ceb5810af5"
    sha256 cellar: :any_skip_relocation, big_sur:        "98a3dc8e453db4dbc71f0ed915aab6e073b21ddf128652ea14aa41d3cb0390d8"
    sha256 cellar: :any_skip_relocation, catalina:       "162f653e5868da31cde97c737012d973bd4e3ce49efa251394c462e4cc4915ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa668c1ca84aa8a4fcef741a42925533ac936a4e366ce4ae5fb20c91b827517"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
