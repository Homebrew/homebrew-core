class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.7.0/mlr-5.7.0.tar.gz"
  sha256 "3896a8be073427671e7ba84993c071891fb39769696fd566b8b77ec0abd3ea51"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1e99a7173ec7eac19ac3daa5fd565016897774c9270def0c95610549634a032" => :catalina
    sha256 "4d5d800c42bedc655093ca0ceb522782721e46af78f1c61e0ebf9fde74f0d9a4" => :mojave
    sha256 "0485537d6ba6927d11484e5c9f3377c51aa0da38fcecbf701c7833f76812a99d" => :high_sierra
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
