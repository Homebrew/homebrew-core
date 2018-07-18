class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180629.tar.gz"
  sha256 "70d11f3f2adbdc64a5b33753e1889918af811ec8050722fbee0fdfc3bfd29a4f"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b005ade6f4bff5392f7b89107031d61bc48bc0db9c6cceb9c01736af8ec424d9" => :high_sierra
    sha256 "b972b7bad6eb5c4b582c1980dae0400c2fb3925b8a4cbedd6008fe008199e33a" => :sierra
    sha256 "b6034ee6f001ab5a2f33856a826c63c2d735d0d73dc9dfc41da627e15696183c" => :el_capitan
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
