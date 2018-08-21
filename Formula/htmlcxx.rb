class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "https://htmlcxx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.86/htmlcxx-0.86.tar.gz"
  sha256 "07542b5ea2442143b125ba213b6823ff4a23fff352ecdd84bbebe1d154f4f5c1"

  bottle do
    sha256 "c46b81a03d14ee9287b79bf6e668669a4c12196b2e9ea7f4b22e8610d61c0943" => :mojave
    sha256 "c948a4b11b8bcc60f03ebc0629bef746189379aed5af0a6391cb5fb66c0fe0b8" => :high_sierra
    sha256 "ebcdff901aaafb18cac1e1bf94e849a4b995e3b583519495fe53c431ed68896a" => :sierra
    sha256 "2be957cd2a735529bc4e921733cdee1b7a7afdfc6614914c76e9fcd08a89c90e" => :el_capitan
    sha256 "b456c9087eb6dc788ec52717cb7eef3bf6dac24dbdd0d46674ed30c8597398ef" => :yosemite
    sha256 "86839a9ca4861d4409d7a71b6553d3cbff78d5f99bf2a72971c302891245ed64" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end
