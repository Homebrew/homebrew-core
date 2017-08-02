class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20170728.tar.gz"
  sha256 "6f9a37125bbb07c0a90fa25b59153b2774f6abe0e43eb1ddde852e43b21939ab"
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
