class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.8.0.tar.gz"
  sha256 "210e998e15b6b34c741a7e1500cf0e98494fe6d019c1fb85305d52e8070f3365"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1954c607fab0ee457851918418d40fc6d5ada7396058bba445fd0e47e2db657" => :mojave
    sha256 "8853e0adc3d20ec4838d84e954bfb90e343154e86545843a1641c8424029565b" => :high_sierra
    sha256 "aa55273d31e7668f919e05084ee86d020079ea88c960e50acd040e03f54f1e6e" => :sierra
    sha256 "0a625d0131a7f928c82194ee3aeec6cfbaffb81e690ae9a66b8bc95267493c9c" => :el_capitan
    sha256 "15d2549f9ec4c3d5a38c6de1c965808d407df5c05ee78a54093d050bb48993a5" => :yosemite
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
