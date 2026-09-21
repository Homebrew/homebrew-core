class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "6aa4638a282a62b9f7be1531309a093350047b35aeb06d0b923d9ceaed6f1543"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "079060d5d6f3f4572aba67e78c1fc83b13b1164a669a93ca517e6f51ae22a0a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a253f7218069e554fd20d68bca1ca7c2a20b8133d50ffbfb070a418ba3a8e7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2da104d768535feb0b10a58da2cd2a3ee2bae55e02c816e64b2900b1eefa138c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e3c55b1447657b41a12077c3bd2df35dc22ea31b36318a9ae4457f77d7c87e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e3fbc1c551ba56dae750777c9945fc7f805567dd7bb1515f846d46ef0fc6350"
    sha256 cellar: :any,                 x86_64_linux:      "04c410b53e51607dcf794f24b30cb8ffae0f92bddeebf6301481ebdcfe9df755"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/permify"

    generate_completions_from_executable(bin/"permify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end
