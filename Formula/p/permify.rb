class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "bdb558b5890ded1da3aa311b6f34da3abbafa2b1c35c2365d902383970fcbbac"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27c3cb84cbf9f948b728f6d79e9eeae296642457240d8fe6be0de805c1d6d931"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1d06220bd77cea546e49305437ce76542787176012a1e5063256cdb1f1a9497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1a0ad353a7b2a6e6b9d3ba84742b9cc34b4b2561d72ef386c74494f101e585b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ceb668b1aeccb4d386478bbb868a4695b5ab9e412f218b685e8e7577d02989e"
    sha256 cellar: :any,                 x86_64_linux:      "438189a95dd506756086f9fd4227c26e197f2640e75c6f018d4f6075638ffa37"
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
