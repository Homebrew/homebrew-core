class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20160930.tar.gz"
  sha256 "8f69ac88fb14ef8dcdb6d5bcfb912115dead15d64cb06f78f44867d2e826c931"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dab087ee98dcc7d64e050f362597cd7a0b4c439bfc15ce3a877b131442c2db0" => :sierra
    sha256 "b4df74bfd2c1890c13ca8eb6f858ce617aff37aaefccd3e4db8f024ff8f55781" => :el_capitan
    sha256 "8da2310058a4452a73be393a7ebb545211582b175dacfd8802b8dcfeef878e8f" => :yosemite
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
