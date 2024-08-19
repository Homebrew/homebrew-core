class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240808.tar.gz"
  sha256 "b59189251b483decd4492f1f74387b2a584c03d5aa4637cd48b38ec62b9c0848"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "110273f82e7b948c0ef48d39a50feef6b518e315b15682f76b4d00037813835d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86fe92a47d1743d0ee44228c2a9b8f04de12b90c5778467ace6da3d8c26305c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630937b9900fd80c18d7134380d7fd231ade970cf27bdf994d4697593abb640f"
    sha256                               sonoma:         "09106532f30316f098475f389c24b38acccf3ff1d70349cc53ac3d2d0a22a5d8"
    sha256                               ventura:        "83c43492a4e759a26dc95ccaf8479b9f243aabcfef4374066ab0dd63990990e5"
    sha256                               monterey:       "010619f5757730df58ffb0bbbcd8b6bdce1d3a9b478f412da49d513008e221d4"
    sha256                               x86_64_linux:   "0734ad24c5f0dc8e809d3559926308876e4729064bda8f2b90505a00726272e1"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
