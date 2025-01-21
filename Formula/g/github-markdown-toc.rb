class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "44d42d08ce50ea446a4feb2737196223976d0153d5f652534b2d36d8847ebb08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "712f57df05a58d25216bedb63eed16efadbd725747ee66a55b5ee1a6ca51de7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e38cb5e3ffac605bac6538721c31fd1660f8bebb3f4f2df8b435acfb37f8d54f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e788122d4d3d7b03b3570af83c9df54b729d37d9b5066ab4a5a132f2b860c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308d23001f56e2aad9784401b66d0c09946c2de10b7326d4f47ca89a046486f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d51f577d44c5441841cb66459a58aecf9df58352e5ee681501ddc5b9f1a1b47c"
    sha256 cellar: :any_skip_relocation, ventura:        "7831462a6c8acd321e14a590858183c708b3bd427e1590ef7dce951524b9424f"
    sha256 cellar: :any_skip_relocation, monterey:       "41aa966bf0d4337c90b1aee325b8c57f9063e1984745bc71665c605a6f4980e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebcf21550d444cfb51592fedfc523b5488d0300986bc299f2b800a90d7118eea"
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
