class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20170728.tar.gz"
  sha256 "6f9a37125bbb07c0a90fa25b59153b2774f6abe0e43eb1ddde852e43b21939ab"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17d32db75fdbbc9f0f972fe2a14b559d6e1ef8d91ce3a5054ac162dc55266749" => :sierra
    sha256 "58f10477cc3568913e6fb2dae9ebcf92a35a59bb5898cf4edd5ca2fe5d9036b3" => :el_capitan
    sha256 "d4e6b9e46a55bb35d3d63d904b88f9596bee23d01a25323b1b72cc31272af633" => :yosemite
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
