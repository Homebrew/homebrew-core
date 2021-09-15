class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.2/mlr-5.10.2.tar.gz"
  sha256 "4f41ff06c1fbf524127574663873ba83bb3f4e3eb31e29faf5c2ef3fc6595cb4"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43dbaa91eb0f047f2189f6108860b7fcf572315186e21ad3f32e753ed9826969"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6a4e253c2f653c0d988aca0a2ed81cf8b8e2ce4040cc43a27582759ba8759f6"
    sha256 cellar: :any_skip_relocation, catalina:      "5538dc76e119ce1507806b67eaa7612af4c68a9a491257a10844545ee2d5a669"
    sha256 cellar: :any_skip_relocation, mojave:        "c04494a29315e246aaa9a553eff17ee4ab4e83a1dfe9a46995ea6e0eebc1221a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7557c7a09a9c3fa1b49fdc7d163efdb6a0916f2fc3b3e9748584a73e0fce3b1"
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
