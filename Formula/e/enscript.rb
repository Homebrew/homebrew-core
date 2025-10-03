class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftpmirror.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/enscript.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "8ec384c474020c7910824f10690c55502ceaa686c444c4989dd3785268dac77a"
    sha256 arm64_sequoia:  "2236c54447fc2e015995a2fa047dd406dbfefa9db547a10b305e5817482d8446"
    sha256 arm64_sonoma:   "3ef28a752ae04d37d64b0b42c1fb615fcb4c374ee67722f7d0884d8567f66734"
    sha256 arm64_ventura:  "9cc559ceab604c4464c02760b4c380f4c6c12a6f87e1dd3216ac8a2788746631"
    sha256 arm64_monterey: "ac95ac1708b9b4d6e7210df933fe8a52821bbd93ee5bec97624898cbacfd8ac2"
    sha256 arm64_big_sur:  "18c0e8fd04b918f671236e5feffe8406c8368369eb08fe301f817e59233659c0"
    sha256 sonoma:         "6da1f997177d346ea16f4750fbf0642fb1c1d1619587436a100e7ca6296e0f7d"
    sha256 ventura:        "d8556f7d35ce02179e429d32250bceb3b0b87ea812a487b204e27fea4485f99a"
    sha256 monterey:       "841ac9a5d1dfd145ce137e8aadc664d747d5bff5e0e67c6176efaf83a1b7972c"
    sha256 big_sur:        "97b523c5513e54b82d963a7b34a4cfbcbe0af74399bc48839b5285cfce29a9a1"
    sha256 catalina:       "3611a6a01c76502ae6d4b1ff13d802acc5b2a2a3f2cf647e6b9323b7e40bde7e"
    sha256 arm64_linux:    "9fc267a42a3689f1a8049af501c924fc2c7c767026018b699cca551db9e339fb"
    sha256 x86_64_linux:   "d968c97391029600c54ace8362e7293202ca6227421d626dced22f21b2ccfa26"
  end

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "cspice", because: "both install `states` binaries"

  # Fix implicit declarations of strcmp, strncmp, strlen when compiling compat/getopt.c
  # See https://savannah.gnu.org/bugs/?64307
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/a24179380383ebda2ad9209f958ef8dd4ce7354d/print/enscript/files/patch-string_h.diff"
    sha256 "0238849f8b78777b30cf2043d19d866ff722992225926440e925a4e49d3ae5a8"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "GNU Enscript #{version}", shell_output("#{bin}/enscript -V")

    (testpath/"test.txt").write "Hello world!"
    output = shell_output("#{bin}/enscript test.txt --language=html --output=-")
    assert_match(%r{<[Pp][Rr][Ee]>\s*Hello world!\s*</[Pp][Rr][Ee]>}, output)
  end
end
