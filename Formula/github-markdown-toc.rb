class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "64e0fc1b87860ced2697ace61e1a91d9b1a14829df08f0da08e797efe5e91440"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9228bf710a91e26eb1c4b24bf3815c14ebba843ed99215ad8514eb41cfc2c68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6a871dcb95229b7f01e7b3aa2e309e50db59ae2707b05777b01e0d1f340437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b7f9b21a20d0ea3adc57e6f1700f22a1dd02a910ff31b90d5e25d7993eb678f"
    sha256 cellar: :any_skip_relocation, ventura:        "2b15946d89399f867064dda64f2565ce167ff1f7a240f1a427a67a3d27eff507"
    sha256 cellar: :any_skip_relocation, monterey:       "18e637f4ace86aa720ffe6f516811d48badfff316273daa441f364ccf6938876"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb4404cd0d9cb9e0470df76d74b6109b4ef6668770d5cced64b0a6a1bb4e6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b776f3f2b25671f686707ae436c0bf3e04df4cbf9dddd1ba49d2cb706a4ff17"
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
