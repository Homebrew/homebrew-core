class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "b40ced38db1ac537c3bc466c67ce8259d67b156844c4576732869e9a8ab16e0d"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71fb96f03d17a970693f5306f63859494918857f9a61205eb8d3f703baec5224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af70d1c9b5cd848e22c42f5c38fe46b859e1a2672ba821a88cb0ec4a1f086133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9073f433ac39555d1db3bed0358395ee8ad30cb1d32620f3e546f11b40a1438d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0297bb01a9bbe46ebe63fe12a97579c5ed8a350ba2015076469a38cfb55b51a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5381f3461758c92b54da79b5ad9db25f69607ae45d13fe863577f7f18e71b222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e142064b2ad31b88f93ba25554ec83d4d9fc7c3592ac44fa1d896a66d38ae00"
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
