class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "https://www.seehuhn.de/pages/moon-buggy.html"
  url "https://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz"
  sha256 "f8296f3fabd93aa0f83c247fbad7759effc49eba6ab5fdd7992f603d2d78e51a"
  license "GPL-3.0"

  bottle do
    sha256 arm64_monterey: "29c7f480f819b4c35a40537fa67645616ba35ba06405c9a433d516ae7684f3a4"
    sha256 arm64_big_sur:  "c7c5841b86bbd9271fb84c33e12babaf31e670dad45b2f65618e052dfbfae7ae"
    sha256 monterey:       "991ffbd762b5a572066a44ce110b400e52892cf487e70e4fab64730c4f7f4fe7"
    sha256 big_sur:        "f4b3e7e9c36f357c628328b247bbe187467f16dde745acfd7ff2f668c22c379e"
    sha256 catalina:       "65bae44959589316ec4762947051a3f737ea8545d0b93e696d0c251ef38285dc"
    sha256 mojave:         "d7baa37058fd1e08a0a9028a912288bde8c0699b50f7632ce792d19d52c9fa73"
    sha256 high_sierra:    "54948d0646240382661b765ab2253258946fb10b2974587d719b24a771172d91"
    sha256 sierra:         "fb2abda84d3e2b20f286caa036fadb9bfd6c4df151352a171385a54ca43acda9"
    sha256 el_capitan:     "b71bfe4abfb1d2c3d35db544850cb56f1b2ba50df18d27d3fef3ed5845b30e76"
    sha256 yosemite:       "08b485a97197d8a0a2733e74622a232a8a1407ebd2564caccdffb9438176c1ee"
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
    assert_match(/Moon-Buggy #{version}$/, shell_output("#{bin}/moon-buggy -V"))
  end
end
