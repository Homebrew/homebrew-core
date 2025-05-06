class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "868a6986ae983b703c9845f315b27ab19207b816a8f16f6d44041e4d78764f70"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11269bcec892b16d8f8402eff9ee2859278e1299e93e922d8cec1528131d97f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11269bcec892b16d8f8402eff9ee2859278e1299e93e922d8cec1528131d97f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11269bcec892b16d8f8402eff9ee2859278e1299e93e922d8cec1528131d97f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9efd21df9259e6c35c31824542f3a8c29dfa3eb7195b227e33e9bfde6e0dd1d6"
    sha256 cellar: :any_skip_relocation, ventura:       "9efd21df9259e6c35c31824542f3a8c29dfa3eb7195b227e33e9bfde6e0dd1d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1871f1b9e169a2b6b1941edd5554ca05aeb3af111a014f8a5692b5921fe8241a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f986c89d832074fdbcd080dafd6ab4a174e43648b9fb45bb855a4b41dd2908d"
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
