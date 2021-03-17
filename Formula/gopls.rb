class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.8.tar.gz"
  sha256 "1d65e7da17009394b0544067c08d9c8c2358164cd07e11bd09c44c6a9bbf297a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff099b70d44477697221a06e7f996c4d94bc03c7f9bd47aa4f989a4b807775bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb97ec44cfcc1b69e5992d5dd7928bb9cae622281435a366a575ee90b07149f6"
    sha256 cellar: :any_skip_relocation, catalina:      "595c7e939049743cf000dd8855a667c444f1cb97fc58ee428c55b8fd6ab3fe4e"
    sha256 cellar: :any_skip_relocation, mojave:        "bda2c9c949449d55d2ae6ef08a1b5f866789caf343d579e58ba0b51375f6ff7c"
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
