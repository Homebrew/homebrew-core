class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180313.tar.gz"
  sha256 "958b5b75617732f6024484c32476cf0759b5777eb827a5e45f1cf3b45d174b15"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7368d05fd9119154e0a73066339a7f664de6ae13689abb153a56ba1acb164be1" => :high_sierra
    sha256 "b66e309f6ed851bbb103e3476f7af070556823f251a497e9104a6f751cead670" => :sierra
    sha256 "c406c5d3f7b17f90a9cb55cc1577c33ccae65f41c7c4b7b5b441417eb1e53b35" => :el_capitan
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
