class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/atari800/atari800/3.1.0/atari800-3.1.0.tar.gz"
  sha256 "901b02cce92ddb0b614f8034e6211f24cbfc2f8fb1c6581ba0097b1e68f91e0c"

  bottle do
    cellar :any
    sha256 "79ea3412dc5437df7b24db916be00ee402c2028620d128d8247f6be2a275c08d" => :sierra
    sha256 "c1b4b17e03ee1685d8b7562f410f75a7c0fa679b00e0505b251741de59eaecb7" => :el_capitan
    sha256 "5474b61b32e2ac3aa5e594c5e617e326aeedc62f8e740b2888ba654db273296a" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/atari800/source.git"
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "libpng"

  def install
    chdir "src" do
      system "./autogen.sh" if build.head?
      system "./configure", "--prefix=#{prefix}",
                            "--disable-sdltest"
      system "make", "install"
    end
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
