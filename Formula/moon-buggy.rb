class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "http://www.seehuhn.de/pages/moon-buggy"

  stable do
    url "http://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz"
    sha256 "f8296f3fabd93aa0f83c247fbad7759effc49eba6ab5fdd7992f603d2d78e51a"
  end
  bottle do
    revision 1
    sha256 "09baeea891ef8e04546714bc917e69eebd359a3bdff2340f270f61e76653ac2f" => :el_capitan
    sha256 "45fd9404d723b6e49dadc612b85b39ddc2534685e9135b940b58332b61379df8" => :yosemite
    sha256 "a3a4c2e2d6e808524107ca651bfeeb8ee063ca5dd2d27054bdf1ea705553bbc7" => :mavericks
  end

  devel do
    url "http://m.seehuhn.de/programs/moon-buggy-1.0.51.tar.gz"
    sha256 "352dc16ccae4c66f1e87ab071e6a4ebeb94ff4e4f744ce1b12a769d02fe5d23f"
  end

  head do
    url "https://github.com/seehuhn/moon-buggy.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    assert_match /Moon-Buggy #{version}$/, shell_output("#{bin}/moon-buggy -V")
  end
end
