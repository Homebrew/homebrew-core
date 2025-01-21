class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://github.com/acpica/acpica/releases/download/R2024_12_12/acpica-unix2-20241212.tar.gz"
  sha256 "e87af02667dbf19416b3f97998cd1d3dbdb165ab189562c90935b3dafbfca964"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef5eb8ed5a1c5bfaf4ed61253cc84e246190739d535b7644185c49d69aa4da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226c303561af1a81d6224a28fb26072f34c6d24658fbcee62058180b8d0db7a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b74ad3dfc593213cd4d0bd4e354878ce0a2ce96f0676c70f7b53cd5becc6e503"
    sha256 cellar: :any_skip_relocation, sonoma:        "61fc69ca8a10856f5bf4f8e0313183087b877e9ef61bbea4b29852ac0cf3c6ad"
    sha256 cellar: :any_skip_relocation, ventura:       "f22d9bc0d7f378aaea1e21d25e9a4e19a2930c0a19fbbb0cc3ef9adafdca5f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ad276be00d30ee4a90f4cb5cd76c1bb28b03d58023fdb7cbf1a10919685731"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    # ACPI_PACKED_POINTERS_NOT_SUPPORTED:
    # https://github.com/acpica/acpica/issues/781#issuecomment-1718084901
    system "make", "PREFIX=#{prefix}", "OPT_CFLAGS=\"-DACPI_PACKED_POINTERS_NOT_SUPPORTED\""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"acpihelp", "-u"
  end
end
