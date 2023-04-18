class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fa112b96c7cb11afc60624e0cdbd2f80157b09c7f0dbec1ec3ba1f92ea7b8f26"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85658f12f74c26d39c28d48e07b64dc28ddb5ce89f146bb39fcbff1ff6a7e40d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85658f12f74c26d39c28d48e07b64dc28ddb5ce89f146bb39fcbff1ff6a7e40d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85658f12f74c26d39c28d48e07b64dc28ddb5ce89f146bb39fcbff1ff6a7e40d"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6b00974a29370cf1641ec7db718868d28014b823b430217d8e9dbc7eb2b5b9"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6b00974a29370cf1641ec7db718868d28014b823b430217d8e9dbc7eb2b5b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab6b00974a29370cf1641ec7db718868d28014b823b430217d8e9dbc7eb2b5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b4243695c8418fd596cf35f59efef7068a3d6f2aff2158f1a4f8e6dc1d7d8e1"
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
