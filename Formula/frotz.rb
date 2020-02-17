class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.51/frotz-2.51.tar.gz"
  sha256 "7916f17061e845e4fa5047c841306c4be2614e9c941753f9739c5d39c7e9f05b"
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "9e152d332b98fa59ac24f12c965b7b8130abf02157bed73c82a1d1379962409b" => :catalina
    sha256 "d3c4e36ef1eb239daabf8aa4dc29bb8c0b6fada88d7f1924f561c0a0515d0b5d" => :mojave
    sha256 "33ee071a81fb2fd18d4222659fb522115a9afa3e15228a5005df25713ac69b3e" => :high_sierra
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MANDIR", man
      s.change_make_var! "SYSCONFDIR", etc
      s.change_make_var! "SOUND_TYPE", "none"
    end

    system "make", "frotz"
    system "make", "install"
  end

  test do
    assert_match "FROTZ", shell_output("#{bin}/frotz --version").strip
  end
end
