class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.18.tar.xz"
  sha256 "f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0fe54c5705842618e6446c4c804330df89a78ed09bd5b013b2c5fabf34b218f" => :sierra
    sha256 "7daa296cf49de573214b4f2c72e3b621bbbc1ef5bfebfbe00fb18a70ba8e3152" => :el_capitan
    sha256 "00d9327f2e8a59996228569bf4faff1c6550653eb3e20353e77f73a34063f3eb" => :yosemite
  end

  keg_only :provided_by_osx

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
