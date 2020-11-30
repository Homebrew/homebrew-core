class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.1.0.tar.gz"
  sha256 "7a17f40b173fd4abb963264e5624582cc7e4e903428c667852bf6f2e9278a782"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99fbf5a57dc8acfcdfb315e14e89886f01584536888426626f7cd594c54c2388" => :big_sur
    sha256 "b4f9d659136a64866c45db6175dd57c366a05b99228e59c889714ae07810a9d9" => :catalina
    sha256 "599edae04915747981605739964b0f496e22d434005be54cc7102ff64e592ba7" => :mojave
    sha256 "44e9a44b52c69571064b4d316f99b1b0ba9b87ac0453e2f0e69a8da65513c9f7" => :high_sierra
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/github-markdown-toc.go/commit/0870681.patch?full_index=1"
    sha256 "e7e316610b05dbb8c31acf3cbf10a39078a1620875a93cad3c76159a5f96a257"
  end

  def install
    system "go", "build", *std_go_args, "-o", bin/"gh-md-toc"
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end
