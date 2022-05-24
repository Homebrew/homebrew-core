class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/v0.3.4.tar.gz"
  sha256 "41c63b892e9a1488c5380faee83d341482352199175588fb46fa838f3b75e6a3"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc74090b0abcd15cdcc1f2a23450ad6dcd7255ad4826932d613f53409a9b96ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc74090b0abcd15cdcc1f2a23450ad6dcd7255ad4826932d613f53409a9b96ae"
    sha256 cellar: :any_skip_relocation, monterey:       "9d4ba59c2ac8d5f10dc848f68704647f8fb6e67fd447efd1a2c81762c40f7d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d4ba59c2ac8d5f10dc848f68704647f8fb6e67fd447efd1a2c81762c40f7d64"
    sha256 cellar: :any_skip_relocation, catalina:       "9d4ba59c2ac8d5f10dc848f68704647f8fb6e67fd447efd1a2c81762c40f7d64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d812e1296de5f1ccc26bbafe8a79fd42f7fc19f0b8e34da06c626a692440e4"
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
