class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
  sha256 "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "820a3c85fcbb63088b160c7edf125d7e55fc2c5c1d51569304499c9cc4b89ce8" => :catalina
    sha256 "71f0e76c5b22e5088426c971d5e795fe67abee7af6c2c4ae0cf4c0eb98ed21ff" => :mojave
    sha256 "dffcffa4ea13e8f0f2b45c5121e529077e135ae9a47254c32182231662ee9b72" => :high_sierra
    sha256 "bb4d19dc026c2d72c53eed78eaa0ab982e9fcad2cd2acc6d13e7a12ff658e877" => :sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

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
