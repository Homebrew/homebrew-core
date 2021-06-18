class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.7.0.tar.gz"
  sha256 "443476a0158195be302d7a0be2f4a0751780412d8fa411ac52017834c363664f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a84ef8b9aba5dbc6306269ce58e07eef2a0349a05f7bb48a42297cb21be291dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "565d0758c17abc9af4cc3d493b09d56fa6a16ab26dd1bad6eebcb4456a5fd555"
    sha256 cellar: :any_skip_relocation, catalina:      "8cbcbe1cb64b4b9c9842048d4370cf63ba93e2607b903a586b8cfea555f62ca6"
    sha256 cellar: :any_skip_relocation, mojave:        "9c78fc5b0955fc24f48c15c7288f371315fab978029ca3167c5f587e0110ad0c"
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
