class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20220331.tar.gz"
  sha256 "acaff68b14f1e0804ebbfc4b97268a4ccbefcfa053b02ed9924f2b14d8a98e21"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93eb9f252933302a3b463815f1f137f321fcca1a8c461bc6a57ea32bf3d33a73"
    sha256 cellar: :any_skip_relocation, monterey:      "24e11de871451e436aceee63d7d29c35ef3b632581470fd9b9f8cce9aede5d90"
    sha256 cellar: :any_skip_relocation, big_sur:       "39017fa084f233d4ffdaf28459a67b2fa4f4851a56bb2c36a81f4bf7dc1949a4"
    sha256 cellar: :any_skip_relocation, catalina:      "382e36abee9a15cf8b78605c1414bee412c863726d6b033eeb0dbb5ccc89971b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ad47abe9b2c12424c4916533691bc43a7ea3d8662a2d95b40a71ffaa15ef1e"
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
