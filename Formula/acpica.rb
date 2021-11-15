class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20210930.tar.gz"
  sha256 "3cd82a281a16bc70c2708665668f138c4fc606c31161d46ce77230454ec04821"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b872f35d911d1c82a2615898af5afc4770b76e059aa7a2d3bb4a6659b933bc0"
    sha256 cellar: :any_skip_relocation, monterey:      "26e952c5c45c718c00f2c8d55b1f0024ac14eb171a21d54ee6de9e248782799e"
    sha256 cellar: :any_skip_relocation, big_sur:       "171ca64d2e427e06fee2f5a3e6deb8e68403c8dcb0b505be088f9c363c592eab"
    sha256 cellar: :any_skip_relocation, catalina:      "f1e620c13d2fcb5fd8969f32467c26b588ddc70d4866bb8a9e4740e893f19a09"
    sha256 cellar: :any_skip_relocation, mojave:        "d311e06530b37ddcbdb19f2a7131e0d12fb2c4489905d0a827aa7e8de551fdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a5c8a82145074588085877162245a1c6703a7bf89fd2577f828f4636462d4d"
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
