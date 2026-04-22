class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "62f34f003912244c8d6d94cad9a273ddb3f29f6f01133d16fdefd0c017030526"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36a03267be083fccd7d83378a25ab9e9d9819f52b3a30b1eb2b0ad9e7bf8a329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a03267be083fccd7d83378a25ab9e9d9819f52b3a30b1eb2b0ad9e7bf8a329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a03267be083fccd7d83378a25ab9e9d9819f52b3a30b1eb2b0ad9e7bf8a329"
    sha256 cellar: :any_skip_relocation, sonoma:        "651bdcf22bfdcb7512822aa31736b148a1449e99264b6aae42a928b29bbcdbb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d92072061f88e3951d6a2d3cf94ae9241c3e3f91954bbfe97fd3aa2101bd7177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df41983c9a523db52fb1e52384488d9ed87fbce829d2fbb2160095d82ac75791"
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
