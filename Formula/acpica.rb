class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20210730.tar.gz"
  sha256 "4a0c14d5148666612aa0555c5179eaa86230602394fd1bc3d16b506fcf49b5de"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/current release of ACPICA is version <strong>v?(\d{6,8}) </i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7800ddc95916348c90a0a8b8c091f4e4424c08b27fe1f22305a2f34cb3eaa4f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "159bed0fbe4b4649db890c6129b02dd6fd498edef41e2b9304f4e0cda7b0ae59"
    sha256 cellar: :any_skip_relocation, catalina:      "df736fd1caa83fba4e3a6240310584acc511518b494c0662e8180d0f240fe65c"
    sha256 cellar: :any_skip_relocation, mojave:        "9eaedea5cf3331a714cd67947e1473343f49a24d21dbf9598bf0d820b43700b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c5df9d4e0f3b945d672e759195e498414ddfd1df9abc66e150ca8123fa3d0e"
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
