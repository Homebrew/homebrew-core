class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "64416276c0c5fe0af4d5737a3248824d2a8f761d9655652d661b98a6f4c97d3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d7ee8751ea7e05799330d4d84d3a7fc2123b61d1baba4e321e2755e9e323532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7ee8751ea7e05799330d4d84d3a7fc2123b61d1baba4e321e2755e9e323532"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d7ee8751ea7e05799330d4d84d3a7fc2123b61d1baba4e321e2755e9e323532"
    sha256 cellar: :any_skip_relocation, sonoma:        "d96f8173b9c0f691413a341afa625a9710ecb730f1cdff75eacddb191b8d341a"
    sha256 cellar: :any_skip_relocation, ventura:       "d96f8173b9c0f691413a341afa625a9710ecb730f1cdff75eacddb191b8d341a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e6a947ea6483267d1b3e213c6986632e267c6592bca1da70e64440f625999a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gh-md-toc"), "./cmd/gh-md-toc"
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end
