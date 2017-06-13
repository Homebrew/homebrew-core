class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.2.0/mlr-5.2.0.tar.gz"
  sha256 "e676f0790e86f0664ad11450521b36297f42dc1846577af535ff3ccb7586b4f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "570cb70460ca6d46222c12fc7f056a8c74706cb82844f4d3d2ce6485347df3ad" => :sierra
    sha256 "6dbb19448bbd722098d3d90c5919532135e2eeb44b66d47486abb50f75d7bf9a" => :el_capitan
    sha256 "cf06facba601382668e8ff425b91e1dce854d10b4effe34248e38f45131441c7" => :yosemite
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
