class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.17.0.tar.gz"
  sha256 "efb31aba836c1185e903435c572f9a5cb5955ebc7a04fa2cf089fb396d3924dc"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f744b8a2ca945c67d8a2daf627f9f8418c5aa712bdfb7e18d0f416b1946ad921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b98d60471a5b1816006445f33065f920a2a1a4815d7e517710e869a7d25757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8231afa3a42ea55c2bba139efc23079d0cde1f2b7b0763981a99cb8cb6ff8d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f2a3d0ee959d5a809416b96ca30d149c5f9cf6175536339ec9afb0db1fbe964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "975648bf56b75b20b8c720d0028a2a8b164a07e508f744b269c2b403b58945bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7bcfbd4694f98667b23da62f1c624d6414578853ef149670ed8b842d5455fd"
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
