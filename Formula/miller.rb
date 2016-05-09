class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v4.0.0/mlr-4.0.0.tar.gz"
  sha256 "e2fbeee7ed2ed7f439e329b93590c6a80b4daef64399a2a8ac93e01f154e80be"

  bottle do
    cellar :any_skip_relocation
    sha256 "018f601eba78b578dcfce6dfca19b248174267e6de4dc438ff396fe5f67fcc1a" => :el_capitan
    sha256 "1d1be75d6ca6952be5b6bfb6477436df2e87904a9529b1d39d708fc489aea2e0" => :yosemite
    sha256 "784bcf3afd9c9375b2067cf93df184957c919e84ab74ea5336c2c9c950fa4f4b" => :mavericks
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
