class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "http://www.mcternan.me.uk/mscgen/"
  url "http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"

  bottle do
    cellar :any
    sha256 "c153d4b10bfff8119f6d4c79d3474c987c0f79d8a5ff6b7873e88ceb029d9f9d" => :sierra
    sha256 "03d4fb080c09ce0e063500fba75a2ae76fd6a40fb5d0d81df7fb30db59651c15" => :el_capitan
    sha256 "d549650742775b2031e39695a15fada95bfae507db29a75fac364f0166e42cf0" => :yosemite
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "freetype"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/mscgen", "--version"
  end
end
