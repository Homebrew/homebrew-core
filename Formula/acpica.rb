class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200110.tar.gz"
  sha256 "9d3f60fbe801cf1049f854de23da5c9a569a34267b27b97fab3d66a68c5266b1"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ed3d06adac4eaf1bd59aefb38110cba4a99b2a623332f7470cd69eef3c0213d" => :catalina
    sha256 "503c66b5ec650ce537ad92f975b67d63e5cd8c820236e6f6ff1729ed2c9f62cb" => :mojave
    sha256 "2c5dc2827a8a214fa6be062608b746fa3c2071de0a27fe0d10388c3e7af82dcb" => :high_sierra
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
