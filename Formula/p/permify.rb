class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://permify.co/"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "094e9bf61a81e83924b5a7c88c11c7c07cf7db6337f406cad2c4fca2ea7adee8"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48b578d295b1bfe41d86611827f61445878268bff9f6fcb3d038a63d3060aa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1460a13396f3000c5ad714f976b758a96e219a64509175df19c913e0e896d5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ebe783a220d145a8fb017ca4b06e05b4c6dbb57b48bd71c9b6abe217986741"
    sha256 cellar: :any_skip_relocation, sonoma:        "2044cdbf3bf63af5abc4811d2eed8d90eb97443f65c026caaaab5c0f802d9654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16df70e6b016761fd9d9dcbf53d337030c40bbfcca99722699bf9822f00e4f61"
    sha256 cellar: :any,                 x86_64_linux:  "5c5c2e02b1ad8920c8ad8f0faf851e0e5896a11d94f0112b667fd0916b07564a"
  end

  depends_on "go" => :build

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
