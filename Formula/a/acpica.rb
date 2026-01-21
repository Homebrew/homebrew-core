class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://github.com/acpica/acpica/releases/download/20251212/acpica-unix2-20251212.tar.gz"
  sha256 "4376bf16787a321e39dd3d88523314985d5e7fa6e3123f790390d26496d63615"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85f3de1cd6566556c244b0dca84c06cc7c29b53ec1eef0be2202037c5aac87e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd24e50694592713ffb98e41bc6d0d0db4dd797af82deedb230a7b76eba8ac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3cd2cc9c20a3875d93722b401c9dd7bb67577e9e6a1a23240d78a1556104101"
    sha256 cellar: :any_skip_relocation, sonoma:        "1778c83883cb32166a2386afbbfe234f62449fb7ff71f9e239975211b63e7c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd8b386141067242c82079e32793613adefb98ce73a7fe47c6a538c972a730b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b700c0658a887d7643a4d56ec457f121c4f22579e07c0956c2b8e557601dfc31"
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
