class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200214.tar.gz"
  sha256 "e77ab9f8557ca104f6e8f49efaa8eead29f78ca11cadfc8989012469ecc0738e"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "acfdda1dfc379d58fdb21f6667cf9812dbb59d34f71422096bd22397571e755d" => :catalina
    sha256 "091a82675ebcdb5fb139c340a2d666c1a82e48f8109ab13f62b1f4baa7b45d74" => :mojave
    sha256 "ad9ae3321281f2f05cefb08ecdf002de174b00a58801a2fbb85127328d0cc9ae" => :high_sierra
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
