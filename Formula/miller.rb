class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.7.0/mlr-5.7.0.tar.gz"
  sha256 "3896a8be073427671e7ba84993c071891fb39769696fd566b8b77ec0abd3ea51"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "774f1b7bf61a599880e1a17262d33ebe1c37257059fea337b8ce8c783f2a61ca" => :catalina
    sha256 "7359de070dd9cf58c41f282e32680b153ba69c0bb0b395fe9ff98a94e4ca313d" => :mojave
    sha256 "b28c6cf7230e72b3f6b17881f9b3b950a826b4f080b0405ebdccd659f68898f5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg/, ""
    system "autoreconf", "-fvi"

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
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
