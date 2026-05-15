class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "df7361e4ea5f34de02a81afa06f515bc6379efeb5ab86c154c6a31def6bcb3dc"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4286ac318a8016bd22785c860b1540c4022ebe1a14f61ea381ddef82035abb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4286ac318a8016bd22785c860b1540c4022ebe1a14f61ea381ddef82035abb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4286ac318a8016bd22785c860b1540c4022ebe1a14f61ea381ddef82035abb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0647c7dc3494d335a2b583675171f0296c78e0120bbbe493fc42cf41e5cd8301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76f5b84b6e187aafa8abca16a9637843b6022bd4f9dcfbc576851d952d31d7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec49b1d3c0b50d2a5c44a94b605cf016d83ffc19c63bafae18402e221a0d6c83"
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
