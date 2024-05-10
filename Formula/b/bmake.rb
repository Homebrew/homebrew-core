class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240430.tar.gz"
  sha256 "aa88fc44ff5795c5c14540d25f37f23943f006ab35f922a4523224bc75e1a787"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53f2580532e296f10dc0400c7735ccce00ac9faabd4f6da145f28bc7db111aab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "554f00edeebee80a6c914ee69dba520525401a6061db31b394cc92bad37d4c0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5ec5abc6abba99b031edb22f1e0bc31992b9ccb9fe004041a0f20021100045"
    sha256                               sonoma:         "e258b681154ce9e3ce98aa7dc0c5b56808330448e28f48e1da1e35c51cf6feb1"
    sha256                               ventura:        "7ab9457ae8189f742477303729122ab0c9f0f97144716edd80de8897b24bff93"
    sha256                               monterey:       "675b2dc709e1cb962e796409b8c4f254c8576a8f06838f3ee3b300a9555a485e"
    sha256                               x86_64_linux:   "452ddbd181a82123146d110876bed0d6a4a3f565025c780c6caba0161bb94704"
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
