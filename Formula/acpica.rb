class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20201217.tar.gz"
  sha256 "df6bb667c60577c89df5abe3270539c1b9716b69409d1074d6a7fc5c2fea087b"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f16065c854d5834feb74c3e5c165b39da78415cc798c54cfbac81b647f197ba5" => :big_sur
    sha256 "e9a5ace2ed89d91d2d60e1ed38426c2cca062f77c5e86604f9eca3f04c77077b" => :catalina
    sha256 "5bf386308429f126f01b394ad83ad6c6784e0ba08c609d06c07a3b10f7acf1df" => :mojave
    sha256 "96e73dba9490131e0da92bbff6c8f5be07b7ad7828067baded32e4d00c40e923" => :high_sierra
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
