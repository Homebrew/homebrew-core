class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "60334cd057f2ce89aec79375ca31682e4608084a7cbc3e32dc1db797495e600a"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eacd2e0261129d66c9a0c4223d8d4cca0d0d6b581946e94b8a9df25afe18b244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7196a1dca404b4a6bbe743ee05878e07dc9e6fca9b64ddc268cebab185469b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ec6aae95f485544df7fe9524e1bff003d8ebaf5142524c0ac8136d5cc11c26d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7e4a9555571e310e3d804268966c9ca3dab6cbf7f9ba69d4b8f706f715bc0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d912fb45948fb68be9fb6dd4dad6a238937f8524fc46b7175558bbd73c4dcb63"
    sha256 cellar: :any,                 x86_64_linux:  "d76802d9dc1b5fb9e1ecfc20a8f779b13b441920c2922cc238db721d8bcd3c9e"
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
