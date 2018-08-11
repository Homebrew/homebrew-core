class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180810.tar.gz"
  sha256 "2643911d0e74c52e4122b914dbbbfa8e2559e4414342bc45f268d2fae32c1ef3"
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
