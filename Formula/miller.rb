class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.6.0/mlr-5.6.0.tar.gz"
  sha256 "325f9acabd5b1b00663b03c6454f609981825ba12d3f82d000772399a28a1ff2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4408cd3525cb889d6155bccc924d13d4200e740eb96b690774f9e4ac39320bc3" => :mojave
    sha256 "60c3a2b069fa775ce738157a3a5eb03876c9be3fb30c43d3185368b2d409aa32" => :high_sierra
    sha256 "513f825d76b80ebe88e5fca356adfa300dd0404621d3a6f80acad4a0f37dbe15" => :sierra
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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
