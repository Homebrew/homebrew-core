class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.18.1.tar.gz"
  sha256 "db9eca9fdfc2e524a8ad8a03bdfb748fa3747898ca6191a33493da945e72aa8f"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c857867ad36dae107712b7381c8ce71ba0889b02aa22cd49f4c1612da802815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a005f1b3983d3339fbb01108d099ac540a7b25df04829253d28e9694df454e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83fbaa9fe3560bfaebd93360fa5eb4b94be545f9798b6006c9a1c053f93e019"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dcac59c9b20beda3a9d83fb20a3d10e386098913df90c9aa05b33dbb3abce13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c33b58178ab898eb62f21fa70cdf8a2475d80f7309e431cabd9a2b05760eb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b71ef5228258936742b3d2abe525845d3d055de27efad677535d86ae075dec9"
  end

  depends_on "go" => :build

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
