class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200925.tar.gz"
  sha256 "d44388e21e3d2e47c6d39e9c897935d3f775f04fec76271dcba072c74f834589"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4adbf549a5bd606fdbd3699c9b7eb24f3b633db7a1f7e03fc12f2c4a841af36f" => :catalina
    sha256 "62c47c95d365b5d124a1269422a92946de2c0d837bf5311a4bc6427b9e753aa9" => :mojave
    sha256 "8698280cdde4907a7d5d1ef4f2c5c5706dd3298070505744dc170039768c539c" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
