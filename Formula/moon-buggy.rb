class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "https://www.seehuhn.de/pages/moon-buggy.html"
  url "https://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz"
  sha256 "f8296f3fabd93aa0f83c247fbad7759effc49eba6ab5fdd7992f603d2d78e51a"

  bottle do
    sha256 "d7baa37058fd1e08a0a9028a912288bde8c0699b50f7632ce792d19d52c9fa73" => :mojave
    sha256 "54948d0646240382661b765ab2253258946fb10b2974587d719b24a771172d91" => :high_sierra
    sha256 "fb2abda84d3e2b20f286caa036fadb9bfd6c4df151352a171385a54ca43acda9" => :sierra
    sha256 "b71bfe4abfb1d2c3d35db544850cb56f1b2ba50df18d27d3fef3ed5845b30e76" => :el_capitan
    sha256 "08b485a97197d8a0a2733e74622a232a8a1407ebd2564caccdffb9438176c1ee" => :yosemite
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
