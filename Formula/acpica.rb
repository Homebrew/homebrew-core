class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200430.tar.gz"
  sha256 "fb807f1dec31664f972af37d213abf72987afe33abf68c83051e298da35d297c"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed7b75181da19348712bc945e439e1c3c078225acda830d54d7f3d90d65c6571" => :catalina
    sha256 "24c202172a1d74c1aae72df631a74705a8066f89801b626ff28e613b8b7f8525" => :mojave
    sha256 "38c99a539407a5768a4fa3d80b207cd85b89d558038099a4b60b7616e16f36fb" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
