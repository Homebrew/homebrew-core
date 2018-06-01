class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180531.tar.gz"
  sha256 "8f6cdcaa4039c2b3db141117ec8223f0e1297684b8ab47839e211bddad027665"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d859158c139fe7108c8ad98d15212143dc4d13f774bf8df6c685db77083051bd" => :high_sierra
    sha256 "96eda907fdef09f7b8a6b493d24bc669825be7275368fe1bd40201e297c60431" => :sierra
    sha256 "ba1563c849bd692a9034fdfc6d6dc277b42a8f6326a451653461acbe77878451" => :el_capitan
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
