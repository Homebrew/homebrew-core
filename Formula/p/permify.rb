class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "6829a09d07c4593de6839c087b0b402b21d481129e99ce8775a9265bae4e7193"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f4ce6c61931f0fc14879fe98034ce4477915ec26d621af727a70341012d1c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a790f84124a6523c1c1c69a4631ec9f324230b3cb4ff10ac3464ac99f160a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f59db7f5569954baf078f5cf9796bf5e957d4b3edb819f5fa99e71f1b9beaddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bcb2c91ce75b61c9d8a19f265cafec75b8c5d09227ecd7d9880b1ebcfac7091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a584b168d036d4685beeae99f6e47b0c3943cb3aa345bd4f427bd813f719c0"
    sha256 cellar: :any,                 x86_64_linux:  "a238cb8342151313b06df6f900df4bbcbe8b4622549cad8287ad87e21d6c46f9"
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
