class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180629.tar.gz"
  sha256 "70d11f3f2adbdc64a5b33753e1889918af811ec8050722fbee0fdfc3bfd29a4f"
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
