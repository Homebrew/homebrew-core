class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.8.2.tar.gz"
  sha256 "761aa768e82a958e6f803db39215c995fe0f263df825ed1cbb9f6b2989f0cd00"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{(?:content|href)=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337236b83c398deac133b535f83c48452445e9a273361caf1680e63a6570ec0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe9730cfc88ee04c18be9cbda3f38a596aa1b50c0fc96ce30911986495b1cfba"
    sha256 cellar: :any_skip_relocation, monterey:       "825140dc0d92b60c6329455ee7f0a70897e45926c1431f50bd4aff8f949c3066"
    sha256 cellar: :any_skip_relocation, big_sur:        "86234cb3eb7429269e93aa7bed8ab522591990f555227b5ec2362edf73e582da"
    sha256 cellar: :any_skip_relocation, catalina:       "31f47f1d077b7129f424c4f0dc7eb9789a5f65d09f5a627a76d9c3b5cc16d88b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48588e2e6c4b9743cdf4b026831c5f0701a16453892871831dbc46c3ccfa9047"
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
