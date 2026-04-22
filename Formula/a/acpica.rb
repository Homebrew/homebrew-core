class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://github.com/acpica/acpica/releases/download/20260408/acpica-unix2-20260408.tar.gz"
  sha256 "5fcef9f0d00ffaffaaa82aa49c5ea9687986e8a7bd60929e298cc99a6741ae24"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93063d10f57ed6b6b5803892fc39a0dc8db3b7952114bb7a5edb414c6e4b1b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5944c5ef47c213f2eb1dd1d7278397c2e5c3131d295c1124c744611d32ece414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "501c4183fbe8ead59efb205280f4478e1f075b3f8da4e1642781ad8c793848cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b9e1d1110bfba1109e1414a60f935f367b7dcb5123c706da37bcf5a560a963f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518e03cb95755a74daa688af925052098664a3c302c108eee03383979b87b348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f274a730f1b55c7f96e2d937b7cc4ad6e20a0a37a5da4e31afeba96bd705aae6"
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
