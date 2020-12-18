class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.2.0.tar.gz"
  sha256 "6bfeab2b28e5c7ad1d5bee9aa6923882a01f56a7f2d0f260f01acde2111f65af"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f69bb8b399201b3f09f24314f38c87d0c78f4094ed352b77dc489ec7d4ee760e" => :big_sur
    sha256 "9c593e7c243a1b1004ec17f7a291e0036ee235c14dd653a197d2484d827067d7" => :catalina
    sha256 "c882d7acb38036793ae4746c29f37e08fa4bc242526080481ca08d4775d9cfaf" => :mojave
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
