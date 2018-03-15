class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 2

  bottle do
    cellar :any
    sha256 "0da7ed90f4bf73aeea7079ab46e5b765491f3929be6d55651dd80cfc9dc32d53" => :high_sierra
    sha256 "f3a31965bcaf187dae9a46b8f7acf02af7d9bbadb21bd834197ed12699b63c25" => :sierra
    sha256 "16fd34adec21188f7e13655cde69289acf0a87f4241395357f1c4d47f492eda1" => :el_capitan
    sha256 "8fbfede40ab806d8a93c1551a00af4aa46f7289d47fbb96836c58197f33e13a5" => :yosemite
    sha256 "b55d226db14edc9ada42ecfd00ae64497702c616247fc8d5d7c35c01d25b26e5" => :mavericks
  end

  devel do
    url "https://github.com/stedolan/jq.git", :tag => "jq-1.6rc1"
    version "1.6rc1"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" unless build.stable?
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
