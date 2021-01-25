class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20210105.tar.gz"
  sha256 "a9be7b749025e60f93fde2fe531bfe0d84a33641d3e0c9b0f6049f996dbb1ff8"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea6c345fc7d1e7e7b0b4ec11230cd82272289837a0bdd1eda6e77bf7a8da3cb7" => :big_sur
    sha256 "981ccd20f769657e066a915afbefe4db83b5b292b8580017939e305d40b72923" => :arm64_big_sur
    sha256 "039f6aac0aa654c064d4115c365f95c924e064eb8f9d29560f68eaf0848131e6" => :catalina
    sha256 "c8a1a05b4aaf62c6d022a288da490366dcf8f5d6258e52a4dcbe77ef862077fa" => :mojave
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
