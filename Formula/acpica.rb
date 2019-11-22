class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20191018.tar.gz"
  sha256 "029db4014600e4b771b11a84276d2d76eb40fb26eabc85864852ef1f962be95f"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2fb3b1810659d78691bdb2a184c9160d901eca267ff0b95cd34b460e6fa2b17" => :catalina
    sha256 "597666a9b6c06fcf02e990681f9dca68a46cf4a9cc87ffb16f5a0d2ffa556526" => :mojave
    sha256 "cace68099063a2a9aca3277aa6e4ee074714c624c13752c3f2cc89af5ba841a1" => :high_sierra
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
