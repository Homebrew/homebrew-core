class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://github.com/acpica/acpica/releases/download/R2025_04_04/acpica-unix2-20250404.tar.gz"
  sha256 "2abeef0b11d208aa9607d8acde07f3e5cee8cc7a43fc354701efa8075b2e5a9f"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea322ed5e903610d9264f0a46378ab8cd867dba115ef74782dce02bcfd51c80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc4284d256259dcb212c0151422a3689136ba2fc7c706196c4913128644b621f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b05e09052930c392a5faebd81fdcf4ac304eb0a52ae04914f0a6f2581396518"
    sha256 cellar: :any_skip_relocation, sonoma:        "140b8b8f802f2ab3e279d54f6f8fe6d0ab267630576d01485bf26dde264f27d8"
    sha256 cellar: :any_skip_relocation, ventura:       "68c95840000e3a84257a8e9f8d6ef67619e22a468cb53651a9c67579fc95a439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86f20efa2264f377f9b690e5624a0758a7b43219fe1f1fc323d774745a97af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dae5dceec9bd03b975f711f49017095a38102f7dfa995906842dc0023fa602bf"
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
