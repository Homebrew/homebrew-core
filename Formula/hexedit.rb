class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.4.2.tar.gz"
  sha256 "c81ffb36af9243aefc0887e33dd8e41c4b22d091f1f27d413cbda443b0440d66"
  head "https://github.com/pixel/hexedit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6630b5d6b6d1fb2b695864ce1c9a66d2ab35052c1d5db3163a1662b8c27ce7b4" => :sierra
    sha256 "a9b9fb50248ed14039053bbd1bf854858423175f30df85a1331ca7db168f6249" => :el_capitan
    sha256 "8e7bbf29e6f6415cf2b1c04674d66310e21f902421982b0550f4feef19586bd7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
