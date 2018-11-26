class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
  sha256 "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72"

  bottle do
    cellar :any
    sha256 "d1c2b64ac27e4826a7b1104082d092cd67df8b76a9df2697035e7e2efe494559" => :mojave
    sha256 "d560b85d7854c50fbf32c921a438e222da877239af960aedf739997577fabb38" => :high_sierra
    sha256 "b59d708875afac979ae7a16456cf2715dabe1cb14decc1064faf0bfb8cbef4de" => :sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
