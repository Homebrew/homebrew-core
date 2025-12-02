class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ce39188595eb40e42f9a8a78309572175002ef20e6fedce2b2555804d9dbc8ac"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb5f3f9e4f92b20965f1b2b7f0d9098b6354bc66945ef2fc1ac65feb916d0a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a7fa10722e10f55653a02b3e71797b0d34fc32993236ea71a9588066366815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918c14561f610e913c52fecbf4901b503d0c84f81f5eac0688fd3c1a59ac3bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab1a94b826b533555df400923c6375b6d9ef918f26139dfbfe6a47c83c14ea50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210fa86f9f742e5aac1399454413b4661c8110e3e793a10bb7e7f377e4573736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bfb0060250e436b8b22cad46ec6fc8ade654b2e619c3e81b8478c9e1ef02f93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
