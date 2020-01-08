class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.6.0/mlr-5.6.0.tar.gz"
  sha256 "325f9acabd5b1b00663b03c6454f609981825ba12d3f82d000772399a28a1ff2"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1b66317a06c90c4727dbb51796ac0b2b79690dcef5c19f703da41d43dae7a173" => :catalina
    sha256 "39fad1f8eaee23cb0135469b016b01dc6f1117f05f197df2e483e4661ebe2710" => :mojave
    sha256 "a3c4e36c09ecf0d8335527e8261d9a4caa9277f6510b35daae4bd758e7b43dbf" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg\s*\\\n\s*mlrp/, ""
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
