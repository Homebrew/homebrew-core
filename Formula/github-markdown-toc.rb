class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.2.0.tar.gz"
  sha256 "6bfeab2b28e5c7ad1d5bee9aa6923882a01f56a7f2d0f260f01acde2111f65af"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaeb4ccfaa12ec8914842a6a9f6b68cc1c393e617d17af87832b2d3500a41458" => :big_sur
    sha256 "db9ca9d24519c3cf044a6c461533744a020a69e569929299159164406d80ccc2" => :arm64_big_sur
    sha256 "1ab9219a4b4e5280248b2aab4ee29f3956dddff78c70b941800948e2f72132cd" => :catalina
    sha256 "f4e584f9514dd801a4d3243e9d962f12fa32cd3c6c62bed6037f4d1232153d0a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"gh-md-toc"
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end
