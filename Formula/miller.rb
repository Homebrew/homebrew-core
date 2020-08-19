class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.9.0/mlr-5.9.0.tar.gz"
  sha256 "06d995667f48a59818979c1ca6d4192f784796f8612550e1a2b24d63a0802856"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "059dafccaf44c5ec084a9a9660433c9c6157df1e4dbb25e9f29d3d057a451b4f" => :catalina
    sha256 "09454642fc0344298fffa89f13c2a0544537f524450fa3b2f8c7039001d41f77" => :mojave
    sha256 "fbeab224dd44fa0dc23d1e3424183262546f6f0bae15c3a33e186774f223f845" => :high_sierra
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
