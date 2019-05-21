class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20190405.tar.gz"
  sha256 "de01ca0e5c4b064f2170b2888c40f595cb896748aa8b4a8e5354a03696549034"
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
