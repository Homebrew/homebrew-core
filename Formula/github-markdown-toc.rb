class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.0.0.tar.gz"
  sha256 "0a13627a29114ee817160ecd3eba130c05f95c4aeedb9d0805d8b5a587fce55a"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb8ff2eba1c3a19aede0151b60f1759ba5e9c9056fabd11e4a830024b2155272" => :catalina
    sha256 "0f96d95ab270819393d74cd6daac7cae2b9b996d1ef1f13a575e59e3f355f27c" => :mojave
    sha256 "633c4cbbc1dd8d1194bfbefe0883266f6b61121ba343b83707d77c3cce8d9922" => :high_sierra
    sha256 "c462dd1fdbb04f213f6ad1423b8e659766082760e0fbdfa4451807d97a8ce567" => :sierra
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
