class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.3.0/mlr-5.3.0.tar.gz"
  sha256 "bcaed67b1d4d4ca73426f1e71a6bc4ad48ca22adf44f579a45d2f9ba623ddffe"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa731e94f52f44d7d598612cc49d5d25a1d4e4cccad2b4488d453004cc0cb22d" => :high_sierra
    sha256 "4564430fef0f7e7ab7b03b0929063acaa89167ba00ff37a0afc1aafd7296df11" => :sierra
    sha256 "5eaa3e9acb063754e26019ec6762fd973e4fd7f7eb8d47691cea85bba2c9bfad" => :el_capitan
    sha256 "a0ec992d0bbcbca769688bf2f6f7a1849447f92a30bd85f6429fdd6faf3f1024" => :yosemite
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
