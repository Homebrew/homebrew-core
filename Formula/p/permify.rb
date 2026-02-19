class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "9aa9c890202af01d038124fb3e278cacd43dd58bf5b902e64e3930fef0c0b9c8"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f38c69184d524db162f533c508989d9905c1e161c53644d6a385aede3645b0bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132c30b0cfcebd459b6731ca1427cab52f848188c4cbf59bae98194664f23c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe1c0fca53dfcf7d5d61c1b3138cd8dad277dc6cf47110ccc6cb8b152d7b1d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b08fddcaaa8891f2c25d200432af1d01376e77ca427af36501f0fe20466069f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d5508b22f763d08db0681ef58d1582400a105036e63d91e7200d98bfe66159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03dc421b86c60e8355a418654c7f497dffdfe2156d30a4d4310a63a2a2ee71ff"
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
