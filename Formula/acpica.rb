class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180105.tar.gz"
  sha256 "414f843ac6c7c53bbd2a830b092a2a27c49172b0878fd27fe306dd526b78b921"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc9318f8f8178defe8a1d1d44689ff6819e437c75818456607bc5abd55302c9c" => :high_sierra
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
