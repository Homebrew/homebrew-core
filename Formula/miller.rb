class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.4.0/miller-6.4.0.tar.gz"
  sha256 "20a8687a0c5b5fedf4fc3a794ef1cee7e9872e87476e1f24bde8de25799f8c51"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff9903febe9a7fc4ada520b3e67efaa3a112036dafadb9c903b02ef2b7e80b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3f2f449d4339ed1add0199561ec482d672c289df512d78aec2a319d11285da5"
    sha256 cellar: :any_skip_relocation, monterey:       "2933a4dbd862bf553139b2e8f39b0e3d1eb4661495df0e53998095124ddf0313"
    sha256 cellar: :any_skip_relocation, big_sur:        "8385310464dbe71665fc781a9920fa19a6d594b47d2385a341c6fe8b98a06507"
    sha256 cellar: :any_skip_relocation, catalina:       "06973c5c51c9e9d6eab7a304b8815a9890874656e838d7d16a7a987eb0339ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8268679a5c11aef3e4b7b84c687540367e24a303431f1f464b643f84f61c1ce"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
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
