class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.0.0.tar.gz"
  sha256 "0a13627a29114ee817160ecd3eba130c05f95c4aeedb9d0805d8b5a587fce55a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b4f9d659136a64866c45db6175dd57c366a05b99228e59c889714ae07810a9d9" => :catalina
    sha256 "599edae04915747981605739964b0f496e22d434005be54cc7102ff64e592ba7" => :mojave
    sha256 "44e9a44b52c69571064b4d316f99b1b0ba9b87ac0453e2f0e69a8da65513c9f7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"gh-md-toc"
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end
