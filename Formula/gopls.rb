class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.12.4.tar.gz"
  sha256 "746b0e1942c028c62fd8c114242a024faed19009ac64180f2cbfc9480fd45544"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e70efa052441051c50e2cfdc4d34174a2d6d0a294874e3395c80d859cec65f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25092ad1c56c2ba9f4ea782dda9a198afbc3168bbbb0ae1ca4e764666bae7ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfd945415d1f91d30fc4bea5f49d609de317ac70e1f07681741ef41b86a2730"
    sha256 cellar: :any_skip_relocation, ventura:        "c6b00988153d9fa2818e2e817558e989a18e4983a7601906b5124c5f56e5f283"
    sha256 cellar: :any_skip_relocation, monterey:       "56724ea421365fc1602ebb3cbaaa5ebfebe5adfdc66984b1c56a309f60bfcfaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b9279c5f296ddf5589334419bfc52190d9b711ea7c5dfc2084bc5538718bb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43e9d1e6ea0eeafcef3b3f637b987fc5027f62d9618754514f497bd76207ede"
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
