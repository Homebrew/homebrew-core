class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20190703.tar.gz"
  sha256 "212563b55c5db1eed84f2e6e9abfee60ab281423f018d39dd93b81a08808350c"
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
