class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://downloadmirror.intel.com/835329/acpica-unix2-20240927.tar.gz"
  sha256 "4471a9c92f2f68b84be0647c4376a176fcb68a6289d7679c1b3a430507f65d71"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e365a4578890fecb9ca994a2a7bc162b01aeab1726450d3facfcd4838dd72f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4933bbf4367e5b2996e9090e367cf06381105b6881e7c66d0f387ddc62abb530"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c66ef224e8cd8aab50fa7a8d776a6d3315db285c73cc40efa30c7769d85199"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d013f9272915ad9bc4521a7b1057a87a381a9858332f52cb19472067f80aee0"
    sha256 cellar: :any_skip_relocation, ventura:       "aece8fec1058cc8c0046ef059bda98ec3301f08da7d2cc224631be2e079a65b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a885756d3404a92a82f1a077e5ee31b8acb9e511b62e474ab4d48ea94218f8c8"
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
