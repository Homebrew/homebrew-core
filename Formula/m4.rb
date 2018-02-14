class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.18.tar.xz"
  sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "066b43f14d9422bee66df1a6f62778e805a0308a36243d99e2d584e08a579dd8" => :high_sierra
    sha256 "b0fe54c5705842618e6446c4c804330df89a78ed09bd5b013b2c5fabf34b218f" => :sierra
    sha256 "7daa296cf49de573214b4f2c72e3b621bbbc1ef5bfebfbe00fb18a70ba8e3152" => :el_capitan
    sha256 "00d9327f2e8a59996228569bf4faff1c6550653eb3e20353e77f73a34063f3eb" => :yosemite
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
