class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://github.com/acpica/acpica"
  url "https://github.com/acpica/acpica/releases/download/20250807/acpica-unix2-20250807.tar.gz"
  sha256 "a3df5eb6b21324075d6aff9b1743e200fba5a1b21f35686c2d2b4466b2df6886"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://www.intel.com/content/www/us/en/download/776303/acpi-component-architecture-downloads-unix-format-source-code-and-build-environment-with-an-intel-license.html"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4272d5885464a91f2d73d4fd40572cd1119dd3433d14181aaf148b4c1a3676c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f32cc9b31ebe6e473306036117315a4bc227380cebe27fe439d79ad10885aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d39e58cdf4e911d1b3db8ce1b967ac592c219fb4d089eacbf30386112a3e9ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a484f87cc8f909f8fcd4ff3bdaca228e4f5417ba0436f7e4275047da7d4986e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68e1a5a0237c94a34ab064ce828faa9c074cf1328ed26dc151c93b0a688bfd2a"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5e24b60b08d46aaf15de390cf5edb74225b0f5b8b60ffe7c0f3648671c2287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b5ad741d331ec60b502e9c0f57e8a7ae96a30091ad630802f89b2f33c8c685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d97900731e708343c719eed7cf25d66cc6c345dc0122a6a32e3b0de4c878d838"
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
