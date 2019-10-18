class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20191018.tar.gz"
  sha256 "029db4014600e4b771b11a84276d2d76eb40fb26eabc85864852ef1f962be95f"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5868f39da3cfc40aa68c0b218cfaf153628eb93e6533bc79140e02c05c8ab927" => :catalina
    sha256 "7d706b107b80449a961fee0072181df2817d4e5b240b8e79b77160216dd3004c" => :mojave
    sha256 "58d47231e2900498312dfc82dbabd3e3657407774a39e55f75c18b91fa544b52" => :high_sierra
    sha256 "d084a5acea224f88ee0d287f3ce1bfbb3c85cceaec3ac9230a2f683e5861d16e" => :sierra
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
