class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20190509.tar.gz"
  sha256 "f124ab6e99110a192864b23dc6911d180968dd15b49f95f7adc37d69dd14621a"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82cccbf0e3df5dd1c55dbd86e904b8f14afd849a5a5ad85e8954f93c26b71d09" => :mojave
    sha256 "92afe56545a6f06c41f92f5f3ead48ba3f22780a988cb05275db2e1962ffceef" => :high_sierra
    sha256 "6194b7187c50616ef8c7fa8bcba6f2472a957e1890807e6c45ac8afdd4c7baed" => :sierra
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
