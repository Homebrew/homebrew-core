class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180105.tar.gz"
  sha256 "414f843ac6c7c53bbd2a830b092a2a27c49172b0878fd27fe306dd526b78b921"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4adc90f8762d5997a9aa4403c7ba17f724fc1ee1fc35ffe153da174552f84f7" => :high_sierra
    sha256 "84e858e114984d7cce63dd210b7d99f7876303297ac961bc5fe6eaf40041e84c" => :sierra
    sha256 "4ab919eb65332f379aafd7ae8e1780ec547797b7e8917a5eb79a3432037bea74" => :el_capitan
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
