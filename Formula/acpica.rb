class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20190215.tar.gz"
  sha256 "71133ab2b1b2e2f176a9b5081060571977a3d2c91b36722e198bffa7ce9b0d37"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca895ad2ed43004463000c0dd86f2ed94773565cf16bf5026f4f2e01e95d304c" => :mojave
    sha256 "ead5eaa7c0fda1e28aba6dde8932f6cd87e6ed41cc24ca7cae3a988be8472ed2" => :high_sierra
    sha256 "b8fc8e51abb8bee1a22fc0cfbcefbd16c717f8248e17b5228dcc4eede15da4ab" => :sierra
    sha256 "e1e59d509d939e868ec40fb0a572f6c8c5facf52f2a1e4a6e44e987f3b1e82b0" => :el_capitan
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
