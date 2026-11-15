class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "9a1cc5b77e9929820b1e1ed10fa6d57e2c665bdd3fb0f755cb9a7499e147c37d"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "325a1bc8dea04da4e0fbbf196de07d86f2d94c5e69957934daaa2d1be7250e12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29544133d92d635f2ff3e8988b7dd16441e5158302d15e08689e8eccda114d41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b39f73a0a9c224280cc35240afee09bca0fbe1c3589ed0aee63fd7fd0d5254d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98acb456f871b6d6269b317673c515e91dcf39288d5f6cbc03e76c1e9533c8a4"
    sha256 cellar: :any,                 x86_64_linux:      "b059540f85a8edafb417f4a2489556047b8b70b4e8168c43d469c1a1c20d7260"
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
