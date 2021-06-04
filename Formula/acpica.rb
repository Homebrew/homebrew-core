class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20210331.tar.gz"
  sha256 "b49237a2c3df58b57310612ec3a6ebee69e1a525b5efeec7152faf32a03b7068"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1aa1f43b792f60fd751df642ca64bbee5ddf5c79d12ff3c82bd24bbd866cb057"
    sha256 cellar: :any_skip_relocation, big_sur:       "be80e8afae9ba18c0c99947feaabad58d99307c8dacae431e6f107f437f344ad"
    sha256 cellar: :any_skip_relocation, catalina:      "60ab88557d60cad5f69ef2909a4870b2bc9b9b31aaa5f5e2e51236d734d9aae9"
    sha256 cellar: :any_skip_relocation, mojave:        "cc1aa5177a3b6734225d42af684200266fc9e03771954907d6ced096742f0fe1"
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
