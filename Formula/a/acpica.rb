class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.intel.com/content/www/us/en/developer/topic-technology/open/acpica/overview.html"
  url "https://downloadmirror.intel.com/819451/acpica-unix-20240321.tar.gz"
  sha256 "54a299487925fd3e0551c95f9d5cee4f4984930273983eff67aa5cd46f8f338b"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca6ac27a50ddca345af0b68560b7ed98f99cc7f1e1f54e05baa9dc3ab2d8256"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc6c354fbf85c390a73453899e19012702ce2b3f70892fddec69cbdb3999d72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f3095f9e790bea7e22700aaee279bb701634b2433b497c79ef9e427556b20b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d9463522f0ba27672ad9481cc8b61446fdb687a38f7304697c5fd1eae28ff38"
    sha256 cellar: :any_skip_relocation, ventura:        "08911b72f49ee6010719948991cbc0477cfc415d5bba6727e8e037ef9b7c194c"
    sha256 cellar: :any_skip_relocation, monterey:       "75b6722b526aa97a9b61da965c99200903ba36a7699a4da20603333e8020dbef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13212ac69dfdbe188c0b91a0d80de8e99483dc76c90d60c62b016ba75469c769"
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
    system "#{bin}/acpihelp", "-u"
  end
end
