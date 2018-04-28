class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180427.tar.gz"
  sha256 "ae01b2d9e06192dca8fec9ccba327f766454e10935f98f608ec7de2690fd0c16"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "adaa7d1ce2342578a8bae5db72fe75d47f34305d56a86c99ea7304eca5f82d61" => :high_sierra
    sha256 "8d808727a689efba1f5821d8d2c29ae0f0a9e24623fd3675827c837e3ae3a61b" => :sierra
    sha256 "b96b602f9e260b758ed9c2a6399fa3b6b346a2f9ff62b2ab658dfc4a16028dbe" => :el_capitan
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
