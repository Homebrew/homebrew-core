class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "dbb123474f0c9f39d67511bf243aa7be2699d6c236cbd6c495ae29fc8cb40e87"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e42892767a009e36a86fa99299abac98d914ed752984807b87347df6f311ce99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e42892767a009e36a86fa99299abac98d914ed752984807b87347df6f311ce99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e42892767a009e36a86fa99299abac98d914ed752984807b87347df6f311ce99"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9b874b271f5a5df878c3ee6a4beb532b55ee7c06df7441d340164c47e794a7a"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b874b271f5a5df878c3ee6a4beb532b55ee7c06df7441d340164c47e794a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b874b271f5a5df878c3ee6a4beb532b55ee7c06df7441d340164c47e794a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ad7d585670c797099e995ba6cebbcacb27e467df67e0be711cf5a7c35bffc8"
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
