class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "97d1a180b0226ea3863f7d5fa35899573310b3299abb0220e26e313fdc4f403a"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1256d5d5a729c140febba5d54ad6995c372d115687d2fb65b0338fd204e51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb1256d5d5a729c140febba5d54ad6995c372d115687d2fb65b0338fd204e51a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb1256d5d5a729c140febba5d54ad6995c372d115687d2fb65b0338fd204e51a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3f419c1ce650002624bcfdc51a04ca3d9d61bf375c250d2ef89d689128d0eb"
    sha256 cellar: :any_skip_relocation, ventura:       "ad3f419c1ce650002624bcfdc51a04ca3d9d61bf375c250d2ef89d689128d0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b5535409c8bfb869237ddd8b045cb7eddc9dc9f6ebbfe2014af997d9fa4a588"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_hcl = testpath/"test.hcl"
    test_hcl.write <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL

    test_json = {
      resource: {
        my_resource_type: {
          test_resource: [
            {
              input: "magic_test_value",
            },
          ],
        },
      },
    }.to_json

    assert_equal test_json, shell_output("#{bin}/hcl2json #{test_hcl}").gsub(/\s+/, "")
    assert_match "Failed to open brewtest", shell_output("#{bin}/hcl2json brewtest 2>&1", 1)
  end
end
