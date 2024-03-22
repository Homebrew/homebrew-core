class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.intel.com/content/www/us/en/developer/topic-technology/open/acpica/overview.html"
  url "https://downloadmirror.intel.com/783534/acpica-unix-20230628.tar.gz"
  sha256 "86876a745e3d224dcfd222ed3de465b47559e85811df2db9820ef09a9dff5cce"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ddd72091b044be0051b3af6fa48c80e41203670c385960f7b500fc4b14b6eb9"
    sha256 cellar: :any_skip_relocation, ventura:       "c2811142ad47f32e3595a02897667e8dbee50df06ecf5c252dc584e08fef0947"
    sha256 cellar: :any_skip_relocation, monterey:      "717e438aa297171b45e25d52f2436957df19c164c9b6496bd43307483a5dc839"
    sha256 cellar: :any_skip_relocation, big_sur:       "30bc6c4eb2da2abc6f981eac5d93dc07dcb3c9f1932501b7aa6aa1595ed0b1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e001787a56236df6a2513bde3bb5444378da2df357d08f9aa1fdcc83161c0f0"
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
