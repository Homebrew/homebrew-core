class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "681ef77f32b86a065158575997c48420be148dd4308c4e0bea9c3e617b0f4047"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fb9aee9614b75c4702666a6d70f9addf8e6157859fa89697758623d878ce80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be473dc6c5fcb60c0b3e81fa93cb95b8488c426362b0c0534f725ccc09a503c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be473dc6c5fcb60c0b3e81fa93cb95b8488c426362b0c0534f725ccc09a503c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be473dc6c5fcb60c0b3e81fa93cb95b8488c426362b0c0534f725ccc09a503c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ae77ad35dfda19dc3237e0f9f7cf0b4f52719794ecc6c961087d2a4a42d531"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ae77ad35dfda19dc3237e0f9f7cf0b4f52719794ecc6c961087d2a4a42d531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3ee3ceb3ec84cfe5a4e04f823f0fbed61ed156ade2148ef96271d636ca3a935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db7e8c0d7315497cb12df272d66fc602b8208274ba76211c3fd15384a96e496"
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
