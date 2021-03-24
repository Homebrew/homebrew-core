class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.2/mlr-5.10.2.tar.gz"
  sha256 "4f41ff06c1fbf524127574663873ba83bb3f4e3eb31e29faf5c2ef3fc6595cb4"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad86c3dd3e1776c793a9b7365644f76822cc744f47883368f5a20d29f75cd366"
    sha256 cellar: :any_skip_relocation, big_sur:       "20d101c9cc9a042e5e26f7d64716329fea37bf5a4c59b7ab4fdc3d83b391ec9f"
    sha256 cellar: :any_skip_relocation, catalina:      "f204a76fc153915c89916ba5e137a759120d5983798734970d7e0951949a2909"
    sha256 cellar: :any_skip_relocation, mojave:        "cad85f31fc5fd2107246a7bbbf03670b189734c4d8040a3455b9224e69be34b3"
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
    assert_match "a\n1\n4\n", output
  end
end
