class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200717.tar.gz"
  sha256 "cb99903ef240732f395af40c23b9b19c7899033f48840743544eebb6da72a828"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e32d0376e072bbe080c114842b0a19b300ad8bd844a046fdd4eeb3894363672f" => :catalina
    sha256 "4c61d40a957465fd9d3a90caff51051458beeccf5bac1371c3d1974d0dfeddeb" => :mojave
    sha256 "3a1b395d0c4085f054626a808d059317d23614eec01fb011981a9f546366e438" => :high_sierra
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
