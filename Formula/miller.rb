class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.0.0/mlr-4.0.0.tar.gz"
  sha256 "e2fbeee7ed2ed7f439e329b93590c6a80b4daef64399a2a8ac93e01f154e80be"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ebc35bfd7bcef3a2729cd32b1652b818cd973b8292e9694d8209bb9c7105e1d" => :el_capitan
    sha256 "4dc09af9b4c06016a0211b07af88645581226ad51298ee5376cce6207c15b1a8" => :yosemite
    sha256 "8627cac9ee07f117782ae84775702eb57fb2d5f15442c9592a940367e0ef4453" => :mavericks
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
