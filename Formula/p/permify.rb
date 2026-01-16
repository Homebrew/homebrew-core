class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "db6135bac0fd38a4193bf62e7618b2f8c520bbfd09fb5f2b138d3e0df84c857c"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09ea9126c18970763f80add1ec02f2c7eda1d83540ad9bb8e3bf033f634083bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8b8ed6bd7b5b075fce8c0bce3a33850dda920540fb90d42ec17dd3da796965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0c3b8e5050fb6fc2153142bd70b3a117277d2c3d7cbd8dbc9058211c7c82b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a64c2c26f33df0b8796122c36832b515a03e33892fc0b90c431fa1b32a19f21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a1aa1839131b96a3b3f42474cb12136d98bf49603d80d745ac998dabb74560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "453bae2ba285ea245898cff37f4696b48377818e0ea3b22a7941f06adbcf8ccc"
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
