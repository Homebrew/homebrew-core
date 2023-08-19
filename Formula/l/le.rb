class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "https://github.com/lavv17/le/releases/download/v1.16.7/le-1.16.7.tar.gz"
  sha256 "1cbe081eba31e693363c9b8a8464af107e4babfd2354a09a17dc315b3605af41"
  license "GPL-3.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "95468ba644bd4a29069f7f58a73b43565ce4b1938d6f8abfe71f867375c26844"
    sha256 arm64_monterey: "75bbbb7067c4bbd3eb4e262e694ee0293f83558a0b1393f43ecaab4659b50891"
    sha256 arm64_big_sur:  "0ccb086bab740c6761a159f82e0cadb1ed09e7fc702afd148a6055615d3478a8"
    sha256 ventura:        "dbd85e597501a053d50b15d5a2be4d2627a4c2b78bfa6d520d9fb0cd87320c79"
    sha256 monterey:       "3a776a4b3b24e8a3bac7d1669aecde9790e5bea72c116422af0c5795997c94d5"
    sha256 big_sur:        "5e783b96b482837243218a8c69f0bf5be7a7afa3ed19cb9950fc88342dd65e5a"
    sha256 catalina:       "704e7762fb13634aa7b2fe4cc271747894d8ffcf5028abd0d27497bceb6bc378"
    sha256 mojave:         "aa1144661f13ab5fbe4eb132415da66785ab1b903c8d517df03f40826d08632f"
    sha256 high_sierra:    "b6fad9458d040f9a47a0d3ff003ab5f77cdb9508a5b653c3cddc201cfb5310e2"
    sha256 x86_64_linux:   "e51d99aa9b68a5ba6ec8fb1679f2dd79efd171d01a0921f268ad4247e41a50d4"
  end

  uses_from_macos "ncurses"

  def install
    # Configure script makes bad assumptions about curses locations.
    # Future versions allow this to be manually specified:
    # https://github.com/lavv17/le/commit/d921a3cdb3e1a0b50624d17e5efeb5a76d64f29d
    ncurses = OS.mac? ? MacOS.sdk_path/"usr/include" : Formula["ncurses"].include
    inreplace "configure", "/usr/local/include/ncurses", ncurses

    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
