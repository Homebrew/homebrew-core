class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/0.3.5.tar.gz"
  sha256 "9d91d8f8b9bf204f3827795592a7da89e0dea368a17efe0163f5ef14bcf3bf9c"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d68c637a7bd7529302404463f22c8088cf949af69b3afc43b7dfc593f0ff3834"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d68c637a7bd7529302404463f22c8088cf949af69b3afc43b7dfc593f0ff3834"
    sha256 cellar: :any_skip_relocation, monterey:       "0e7ae11f9d3a4af09e555d6a1b686a20171dc58440fee969a7d36987a7cc4ed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e7ae11f9d3a4af09e555d6a1b686a20171dc58440fee969a7d36987a7cc4ed9"
    sha256 cellar: :any_skip_relocation, catalina:       "0e7ae11f9d3a4af09e555d6a1b686a20171dc58440fee969a7d36987a7cc4ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555a179339a03e652cf9778151a999e3e5fedc66c1c1e4e193293389394d7370"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    test_hcl = <<~HCL
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

    assert_equal test_json, pipe_output("#{bin}/hcl2json", test_hcl).gsub(/\s+/, "")
    assert_match "Failed to convert", pipe_output("#{bin}/hcl2json 2>&1", "Hello, Homebrew!", 1)
  end
end
