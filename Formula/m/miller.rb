class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.22.0/miller-6.22.0.tar.gz"
  sha256 "a6fba59814a49821896be2096aab80eb4818eb26fd2bfce72a231623be38b246"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae20086e916bbe716850278ff3f996f8a48b09420d37add897fea3cb5d3e3bb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb845519ef5f71c8b53284ab935ae550f1397846e4c0cffeeb7c2f093608ffdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf1459de90c3878d38fd340ef13073067c1096bca9bd92d52f797088dae95e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db09359fe64ff5f95977cdaf16aa2aaaca60d2a1321acf174e076e7c03881dba"
    sha256 cellar: :any,                 x86_64_linux:      "466df6f0ce46908a9ccac859a6207a03ac70f3eeb95026c0c4b6264a666db03a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      a,b,c
      1,2,3
      4,5,6
    CSV
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
