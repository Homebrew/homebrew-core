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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be43ecee03d1db69053ef3a6f17e63a583edd06a72fcb241520c03a826a9b6eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98ea66a532bfe6a16de326b8214650f5f32ab356042be1b6d75c411ca7a6aa8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e844d68b5749f2ec48057176e9ce62b58157609d399682b72cff330737f6ffef"
    sha256 cellar: :any_skip_relocation, sonoma:         "f280cf89628d4313acbc532f14ddafb32a54833c364a07fa596bdb96b93779e0"
    sha256 cellar: :any_skip_relocation, ventura:        "8484ab8aa9c96f5e15f8b889e52e4324b3a3512f1c50fdfc359f23848f494d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "540c2a37da0a2fee237d044fd60326b8bdb5f77be6bb76b6b46ba6f3681b8415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a46e92d89efd8ce7f25cd0ee26f812fdea40747df7551d06d97614b0f99ba797"
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
