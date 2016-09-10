require "language/go"

class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.6.0.tar.gz"
  sha256 "fe6995e9f06febca0f3a68d0df5f124726737bcfbcc027dce4aa9d5dfa1ee5ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "69fa10cb92f8674bd610b29fad0708ae30248c7ec1635bbd419cdd6f80f3273b" => :el_capitan
    sha256 "b68351ec94b8aa3ef4ab146acc4397a10737d684a4776642a3c0e8cf07c00deb" => :yosemite
    sha256 "7439b7dd49932ada1b2fc943ff6093a856760c7420048f1f780740fedaca88e2" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://github.com/alecthomas/kingpin.git",
        :revision => "v2.1.11"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ekalinin/"
    ln_sf buildpath, buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gh-md-toc", "main.go"
    bin.install "gh-md-toc"
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end
