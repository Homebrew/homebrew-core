class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.2.0.tar.gz"
  sha256 "6bfeab2b28e5c7ad1d5bee9aa6923882a01f56a7f2d0f260f01acde2111f65af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962254f8ec5d2aba52c3890b19e8e853f7c3edcfb721e2ef36710632129e9d29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db9ca9d24519c3cf044a6c461533744a020a69e569929299159164406d80ccc2"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd4223920e590394f7058cae9f8aa162914d9ada8df5866cd099b09da413af8"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaeb4ccfaa12ec8914842a6a9f6b68cc1c393e617d17af87832b2d3500a41458"
    sha256 cellar: :any_skip_relocation, catalina:       "1ab9219a4b4e5280248b2aab4ee29f3956dddff78c70b941800948e2f72132cd"
    sha256 cellar: :any_skip_relocation, mojave:         "f4e584f9514dd801a4d3243e9d962f12fa32cd3c6c62bed6037f4d1232153d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add401cf034de867d02a1ab98b5072e362af92b0274f864ca99aca90ba2b0ec0"
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
