class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180508.tar.gz"
  sha256 "2b81e45cb9cc5116e9bbb39f8822ff90ec44f9f2bf6fa87243e2cd7376c5f4d8"
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
