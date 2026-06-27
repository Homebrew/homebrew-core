class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.9/mikmod-3.2.9.tar.gz"
  sha256 "214c10aa3019807a1eb26b2c709592f63dbcc00b72985aa86a4fb7ac3cd8b901"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/mikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "a5da0692a2e6e0197f5c349ee900ff9850fc7222e4b15e3d9a08f76d86682c06"
    sha256 arm64_sequoia: "ebf971e2565954c0a4340c3b27d3f09a1087d276199e360f3506e113266eb398"
    sha256 arm64_sonoma:  "235c1f19c1752d44d0eb89e888894f9b4a72a75131c796d5281bf15fdd1df6b4"
    sha256 arm64_ventura: "ef5825cf3c2f07a1b58c596d56e9f965f743788232720529e82acaf10838da28"
    sha256 sonoma:        "5f51f1fc55de88f9083ab08d701523d68ca1675c0c27f8fab6dd1012afc1551c"
    sha256 ventura:       "305dbbedcc5ff0bb6f3853f930375503aa9acf4234889de233070c2f566e3eae"
    sha256 arm64_linux:   "f3c8a4dc7f13aa55e8e613cb91f440ecf23316a250e4e6a1773a4c409fb1b00b"
    sha256 x86_64_linux:  "0ac9b85e2c8c107a3d9d59f8ba8a3e6b316de1b1b28b30f4f2883377d10917e4"
  end

  depends_on "libmikmod"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
