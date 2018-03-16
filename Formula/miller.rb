class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.3.0/mlr-5.3.0.tar.gz"
  sha256 "bcaed67b1d4d4ca73426f1e71a6bc4ad48ca22adf44f579a45d2f9ba623ddffe"

  bottle do
    cellar :any_skip_relocation
    sha256 "c833decfa926e2ba3a1815f2a1d924a1c22b8e87a3e915cf6df843965e967189" => :high_sierra
    sha256 "3242d8648f791da23243f2ba44e081ff9cdb875fb35669e722fc9b2fcf3805f2" => :sierra
    sha256 "abb0e04f1704a2601f613f6ecea3a360425f194084a87f5be0f37ba677b91869" => :el_capitan
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
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
