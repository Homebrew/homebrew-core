class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.0.0/miller-6.0.0.tar.gz"
  sha256 "b5e04ccbcb021bebbd758db4ae844712eb4fcfc67e6aaf39e24f751f45cfd0cd"
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
