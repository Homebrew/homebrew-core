class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.2.0/mlr-5.2.0.tar.gz"
  sha256 "e676f0790e86f0664ad11450521b36297f42dc1846577af535ff3ccb7586b4f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "c14d672575381cc4b6d228149677a62d6c20b98b46c45405475d49658cf959f8" => :sierra
    sha256 "b9066a89086b9a41df20d409de60a9ba4a9e2962a7a916f103e7795eda9f2000" => :el_capitan
    sha256 "5bf090ecfe15ae0d5bb7ccd7525933515150908f9196976c39680a764c16df9d" => :yosemite
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
