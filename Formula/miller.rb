class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.10.3/miller-5.10.3.tar.gz"
  sha256 "bbab4555c2bc207297554b0593599ea2cd030a48ad1350d00e003620e8d3c0ea"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745c0e00c92719c72c3f456dbe1156b635a6f5d02846a91afb685ff40de4eb84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c6c8eabb55854dd768fec35d68f5a3c51cc74bcbd969f547a9efaba752ad420"
    sha256 cellar: :any_skip_relocation, monterey:       "6077eff1c560d0ffb82c57d63cfea591ceb6c848fc9d14876b671343a4e0279f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0b5eea480a0c744e16ddf6982dd5c883aac77033ea5b96c4539834901c86187"
    sha256 cellar: :any_skip_relocation, catalina:       "4aba0073513fd6104e8df701372f21facb78205f5453bf3a871d4a67613bf746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdf09268c39fe5dcb7764352c2ba331a295dff401e8b533986b8a8cb0f186cdd"
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
