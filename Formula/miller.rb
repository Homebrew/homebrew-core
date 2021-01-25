class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.0/mlr-5.10.0.tar.gz"
  sha256 "1e964a97ee0333a57966a2e8d1913aebc28875e9bee3effbbc51506ca5389200"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b19f1751ba3d39d94c371443583a2fd53b035e93c4ffdd8432e6c978ba43601" => :big_sur
    sha256 "6549e28916d341df56a77990fdd06aa3120821447d12614e233b60b6019b4343" => :arm64_big_sur
    sha256 "d806164692bbe7077e28e8deb819c24ab3e7ba0794ffa6073654e54d32538649" => :catalina
    sha256 "bceb6b1ff93c9bb4b11a38af1ce4b4c06f3a572e06f0f8132a9b0799a1caa3e3" => :mojave
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
