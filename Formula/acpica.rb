class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20200214.tar.gz"
  sha256 "e77ab9f8557ca104f6e8f49efaa8eead29f78ca11cadfc8989012469ecc0738e"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c951b6313c4c88a6a0f4cff7d8e9f832f2301f87dbe03590fa18872c57933aaf" => :catalina
    sha256 "77737d68f935fbc09f9a27805c3c86a0dc9c812378cdc512a3385951249347c3" => :mojave
    sha256 "19bde18f6e8eb1616c8ed61b6d12a813252463e1cecfd6b3a22e3c28c895020e" => :high_sierra
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
