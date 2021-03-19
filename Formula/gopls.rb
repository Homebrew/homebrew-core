class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.9.tar.gz"
  sha256 "5057669794e087ae80dc59043210da720b7502f891b356e89bee4be3356582cf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f995c89270d6d4e87bda6205549e14667bae06dceafacc7a99af23e291e5f8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "06a43c8648a45266fb950b59b7781cf81c9e7d580156c12efc919baab0f15500"
    sha256 cellar: :any_skip_relocation, catalina:      "2614eb9791df813d6b34b5c4f087811d94da178ef5ada73062d64059f06f585d"
    sha256 cellar: :any_skip_relocation, mojave:        "5c73a428146cc9667df61ab23db1b2ce84984155d4344eb9f6c5b2d9e5f48dfb"
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
