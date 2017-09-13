class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.4.1.tar.gz"
  sha256 "4104905394f1313c47e22d4c81e9df538b90cec9004b3230d68cd055b84f5715"
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
