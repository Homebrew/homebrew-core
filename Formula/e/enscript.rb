class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/enscript.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "9cc559ceab604c4464c02760b4c380f4c6c12a6f87e1dd3216ac8a2788746631"
    sha256 arm64_monterey: "ac95ac1708b9b4d6e7210df933fe8a52821bbd93ee5bec97624898cbacfd8ac2"
    sha256 arm64_big_sur:  "18c0e8fd04b918f671236e5feffe8406c8368369eb08fe301f817e59233659c0"
    sha256 ventura:        "d8556f7d35ce02179e429d32250bceb3b0b87ea812a487b204e27fea4485f99a"
    sha256 monterey:       "841ac9a5d1dfd145ce137e8aadc664d747d5bff5e0e67c6176efaf83a1b7972c"
    sha256 big_sur:        "97b523c5513e54b82d963a7b34a4cfbcbe0af74399bc48839b5285cfce29a9a1"
    sha256 catalina:       "3611a6a01c76502ae6d4b1ff13d802acc5b2a2a3f2cf647e6b9323b7e40bde7e"
    sha256 mojave:         "a8bbba8f7d64eed40dd59a9db980b049ec786e148d31a0aeb92556959b4ad0b0"
    sha256 high_sierra:    "00045dff3bdf7ac98a19236838d7af7101cc1fc002e55550312042bb2e4d7426"
    sha256 sierra:         "c14fad6cfd67fa782beb7a425eb03c3ed0b8090ed751c37f5f5ec426808df25c"
    sha256 x86_64_linux:   "d968c97391029600c54ace8362e7293202ca6227421d626dced22f21b2ccfa26"
  end

  depends_on "gettext"

  conflicts_with "cspice", because: "both install `states` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "GNU Enscript #{version}", shell_output("#{bin}/enscript -V")
  end
end
