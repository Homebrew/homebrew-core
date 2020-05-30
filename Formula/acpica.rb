class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200528.tar.gz"
  sha256 "e69f81c6924c8d30f9b9005bb002307f07b5a1538e13c909bea2f8a44e0d8610"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "479bdacc3695e96c078c9345d17febe0028b7972929f46e601c3d651182b626d" => :catalina
    sha256 "17dbfaf84f468f6e4a86d383ea4c30e60995a8f3b666ac230d5ac11995a0a797" => :mojave
    sha256 "6cb8548285547bf427709f04b57bdf82ed5e10c65f0b3161ca947c8d60e968aa" => :high_sierra
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
