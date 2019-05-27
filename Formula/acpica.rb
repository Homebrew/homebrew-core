class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpitests-unix-20190509.tar.gz"
  sha256 "112cf041de01d48ee62e728a234776b683d04551f1bdff0d018e4d0843ebd960"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce71dc6b57400215eb5ff55330ba527edf324d217aa72e3435acee7a6d27362d" => :mojave
    sha256 "a5a945e3102510f561dd85ab01861109d0d64c10cc94b8e4f64db941036bdbf9" => :high_sierra
    sha256 "0fb70d72a8f3df321354da54490297a8f0e53643b94aba35f23e80213e496c08" => :sierra
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
