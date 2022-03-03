class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/v0.3.4.tar.gz"
  sha256 "41c63b892e9a1488c5380faee83d341482352199175588fb46fa838f3b75e6a3"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "188a9a985e274d51d656f19774c7aef180d51c2baa89b6a8cfcf7a1653074ba8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "357414d0b2d4cfd38220d4e9d52b556fc431334f0fcd6d62d5fd3ff97b1b2f14"
    sha256 cellar: :any_skip_relocation, monterey:       "2bafed673735a5bc368725750c957e03e32096cf941d61e7be22e080c64c6d91"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5fcea7928871e1f18fc048f103fc8be8e3564856c869155d16d41160a1515d"
    sha256 cellar: :any_skip_relocation, catalina:       "9b5fcea7928871e1f18fc048f103fc8be8e3564856c869155d16d41160a1515d"
    sha256 cellar: :any_skip_relocation, mojave:         "9b5fcea7928871e1f18fc048f103fc8be8e3564856c869155d16d41160a1515d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b2da82eecafa95be718e656620b460e6a36bbb5acd8259bc66e41341b32ae0"
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
