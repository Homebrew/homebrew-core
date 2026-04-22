class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "d9a529fe4cc71b2f8b9efb2a1ae52830f1599b1effd9e88d13a6b8a988bd97c5"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f021e3d84ea99caaa160d1d140992bea344921bcf851699c9145a59eb7103de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd077cb8655baf8f14db87fb277fc03301b7a07663c8ebe1ed4806c118ecc796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28bff4235349c3ea868a84e057dfc2cad5f01dea77d49335c773a98f571dd995"
    sha256 cellar: :any_skip_relocation, sonoma:        "10fdbdb4e5ff2c5a5542102b896323fd368d0dc8c185b775e9f56683eb710516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6c87d033561bb577b7046317f6439e4dc47b1647d6f0e9a9f980fb34fb1ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ab0007da321136ffd43071bcee1df68a3aaf105e4ebe31d30f7879d5b636c9"
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
