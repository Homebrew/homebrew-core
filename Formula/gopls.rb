class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.11.0.tar.gz"
  sha256 "b5dd0040bcc75b4760eb543826b6503a163c835c90f50843e626a112ca083931"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b633984481e7144eefed6c7aa848c2e93dbe3a1a0e71269adb99205f7243f56c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65cd3b09be17beed7eca40f9108786cbd9d333c02cf3cdd8bccc911f1158ed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c1fec481e0389e9d0c738125b01cb780233feb65832223af05a0fd217e9cd15"
    sha256 cellar: :any_skip_relocation, ventura:        "c86fd5138d2195de6c2260c4c8c649031bbb1a26e9669e6f23f1c0b471cd8a48"
    sha256 cellar: :any_skip_relocation, monterey:       "3cad68130e2362b8482f44180a1c34940129010c68e21352cde0ddffe799d27e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4290cf50cc6619b4988007b429dd0902fead044265fa19b16e8024291a55f236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3394c25f5ab762c69e3395bdaf9c445ef45c65fda949804092d70977e257e23"
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
