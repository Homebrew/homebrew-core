class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/thoughtbot/pick"
  url "https://github.com/thoughtbot/pick/releases/download/v1.5.0/pick-1.5.0.tar.gz"
  sha256 "1dac1c9cf0b14b0bbb4d9eefb6af72cdf5314af7b2ff9e4c7c8858014ad63549"

  bottle do
    cellar :any_skip_relocation
    sha256 "328d148420af50a175424027977a508ab2771b706b800effca95b79843953569" => :sierra
    sha256 "966359b2647a1268c4091bb76a7daed22cb4cf1fa96a40a95da8b2d7b54b5968" => :el_capitan
    sha256 "429d8e11ae48b5e23a39039218f4e65f04be09bdd5916fdd2aaa81b467b3d711" => :yosemite
    sha256 "ba74ec54344e9ab11638f6576e46128193b483b3e4bb1739a414f0a8df54ecc6" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make check || (cat test-suite.log && exit 1)"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
