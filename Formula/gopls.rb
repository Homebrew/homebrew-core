class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.9.1.tar.gz"
  sha256 "420fd56ed614fc8a56547ad7737c2d0f163255a6a2953f1e57d854eeb5cb1b7b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6cfc5b3a224682c16bf49ce7bac41f98a88a92cec4d795ff455f469a7cd82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefc79af5df87d507cf1dfa1df84078fc5aca89b448f8d27d0634173c311c987"
    sha256 cellar: :any_skip_relocation, monterey:       "a8686e61aade3c294a3c9e018edc5ce942d3bd51902bef2326cc3357848cc810"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc7068addedd25bb89f4db8448e028537401f5b03f302b8cd8d93573d2daa967"
    sha256 cellar: :any_skip_relocation, catalina:       "37fe6d7612fad14b506ea9d4150f1820dcd7148fb5426dc625a993d6a5e048a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d6864784ae01fe54207d697cf6145fd71f5a9c89c197cae79bd1b0d4d23899"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
