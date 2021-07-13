class Hcl2json < Formula
  desc "Convert hcl2 to json"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/v0.3.3.tar.gz"
  sha256 "e2aa5ef900cfe42ebd9454cfe61b8cf780b4a026dae22e4ef5fc779f34da4126"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"
    require "open3"
    test_plaintext = "This is plain text."
    test_hcl = <<~HCL
      resource "my_resource_type" "test_resource" {
        input = "magic_test_value"
      }
    HCL
    hcl_stdout, hcl_status = Open3.capture2(bin/"hcl2json", stdin_data: test_hcl)
    assert_equal 0, hcl_status, "hcl2json gave the wrong exit code"
    hcl_parsed = JSON.parse(hcl_stdout)
    assert_equal "magic_test_value",
                 hcl_parsed["resource"]["my_resource_type"]["test_resource"][0]["input"],
                 "Parsed HCL returned incorrect data"
    _plaintext_stdout, plaintext_status = Open3.capture2e(bin/"hcl2json", stdin_data: test_plaintext)
    assert_equal 256, plaintext_status, "hcl2json should exit 256 on plaintext input"
  end
end
