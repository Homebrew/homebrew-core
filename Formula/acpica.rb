class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20170303.tar.gz"
  sha256 "c093c9eabd1f8c51d79364d829975c5335c8028c4816a7a80dfb8590f31889b5"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6559f2052950696aa7cce6805b9ca31b1737094e717af2b036dac2aaa40914e6" => :sierra
    sha256 "b0d61f615c1451192d61fc2dad53315b3dbb041a01a7c7a4f94584d02dab4125" => :el_capitan
    sha256 "361ac507c8edd87bfc694d73fc1be7a05a00d3f1f46ee9f7f88e5e139e6fa56d" => :yosemite
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
