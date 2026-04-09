class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "60b626a7009e1ae9ab99f7c8fb99df19c02c83436932b3d8e3a7dab0c9731f45"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04f527683e8cd0f5e47cea2b60d87c7a7616c5efd640855e691b13a08f0f293a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2400820505692afffe0a3c8daffcd1600dccb7669f86768506a7a5801ded740e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab29e9fd74d227a81ac2c8007f40b1c08005c3ca50eacfe9f59d2787e6ab0e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cebb9d19d5053343cfd47e12f449aff7017603f185428aff2bc9574bbf3343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25bccf30f983c34e022fe90c4cd12ce827bacaf97745dd422835e316edc3b863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e643d46722fb5544a52b3e7e65262ea83bcd95ac9e84a0d088451ea8413b74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

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
