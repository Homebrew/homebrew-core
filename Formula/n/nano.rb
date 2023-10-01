class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v7/nano-7.2.tar.xz"
  sha256 "86f3442768bd2873cec693f83cdf80b4b444ad3cc14760b74361474fc87a4526"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "31ea8496e1c04f70abdd25e24c4492c1e6fd783ea0a18bcf9545f15ef89c6aae"
    sha256 arm64_ventura:  "b12fe58c8d442f8f338d319d7934fe439d441cb15da40a8db25b709226cf3a3e"
    sha256 arm64_monterey: "f0554d184323c34a57cef42df8fd3b56afd723af5e97275a3a5628220d4e8e9a"
    sha256 arm64_big_sur:  "50fbf0b54f56afe0a05c98b393e61257c965eca162a32367583d6bf8bf34865c"
    sha256 sonoma:         "3f8738b95f7f786a0575a4d2796b09d4f9b11b9edd7ccce8ada8da62203630ad"
    sha256 ventura:        "2a27a1f2d44f1c82388d8952f05bfcf6ffadc0d08c87a6f62bbda2eda4d50826"
    sha256 monterey:       "db212d2c6de758fc9c0c213ae5285dbb3bbf6978363548cafa4ac3af356a7b75"
    sha256 big_sur:        "65b76ac9bce041b20a5a91d1ff21e511c28f4995f7e8a604395eed57d35c5b10"
    sha256 x86_64_linux:   "e29112cb799708f597542f8bd8bb13fa0a7ba2807ec2634892e78536c08939a9"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
