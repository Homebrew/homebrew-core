class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.18.tar.xz"
  sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0df9083b268f76a3cda0c9f0d2ce84b51d21a8618d578740646fb615b00c7e7b" => :big_sur
    sha256 "1db2471add366dde3b52f8d2d32e6d118584f91d1390d8efd6c10c41c9d6a45c" => :arm64_big_sur
    sha256 "2fdf452c94c6b63ea0a45608c19a4477acaf79853a298d337360971c5d51413b" => :catalina
    sha256 "2c0f28d612ba588cd6bf8380c6e286c9d3e585dcd8c4ad198b955c9e8cd1d817" => :mojave
  end

  keg_only :provided_by_macos

  # Fix crash from usage of %n in dynamic format strings on High Sierra
  # Patch credit to Jeremy Huddleston Sequoia <jeremyhu@apple.com>
  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/edf0ee1e2cf/devel/m4/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  if OS.linux? && Hardware::CPU.arm?
    # Apply fix for https://askubuntu.com/a/1112101
    patch do
      url "https://git.openembedded.org/openembedded-core/plain/meta/recipes-devtools/m4/m4/m4-1.4.18-glibc-change-work-around.patch"
      sha256 "9e8fc660515be565f26194d3d6124a9483dc15a66ee8ea3f0b409c02d60a62f5"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output("#{bin}/m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
