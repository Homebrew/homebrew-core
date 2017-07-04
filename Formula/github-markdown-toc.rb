class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.7.1.tar.gz"
  sha256 "458032ba4e74a0c5284ae476e874986e0c6c96876faf414dac181e5b9d0217bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "947ccfaccb7328b9ebd8b3cab77e2ab0ca73f84d7f0025c3521fcea445c355fb" => :sierra
    sha256 "69fa10cb92f8674bd610b29fad0708ae30248c7ec1635bbd419cdd6f80f3273b" => :el_capitan
    sha256 "b68351ec94b8aa3ef4ab146acc4397a10737d684a4776642a3c0e8cf07c00deb" => :yosemite
    sha256 "7439b7dd49932ada1b2fc943ff6093a856760c7420048f1f780740fedaca88e2" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"gh-md-toc", "main.go"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end
