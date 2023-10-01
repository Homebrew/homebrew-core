class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6e226067f65614ca59bd2e52b163ec1c4b4a86d31b243a0b861cdc6bb8737175"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07f7d49c3487d72b9b721fe7a8b6ed60ade2bae55a186b921fede1850e89a78c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef031cecc5c4833d4434d69b1bfa25601587e781c58f9c5f2c912796664ee33e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f709a5f44c5a146a3aec9ee5b96c526c1f01684c7f07bcdd230dfd8e5d09418"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5147e6ec58ed9f7452d1ac21e253ad2ccd3a811d6b1ebc0c9b5b2dae2837f0c"
    sha256 cellar: :any_skip_relocation, ventura:        "da05aa4967528595ea8b3b028ffbbe063dbec19d7b5d49d148fe179e415dfb0c"
    sha256 cellar: :any_skip_relocation, monterey:       "94cb12926a3f636fdcc5af1ec7e8a2f3fe5a54a60becaff436c5922f915f4886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45725902e7b92871f5e3af3f5cc6c74d3c7711cfe1b35d13f3fccf175b1cef67"
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
