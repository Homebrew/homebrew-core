class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "dbb123474f0c9f39d67511bf243aa7be2699d6c236cbd6c495ae29fc8cb40e87"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50c93eb47adb8566daf0e225700072be8f7972f90281358d0f8b0064e54ef176"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c93eb47adb8566daf0e225700072be8f7972f90281358d0f8b0064e54ef176"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50c93eb47adb8566daf0e225700072be8f7972f90281358d0f8b0064e54ef176"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce30f97cf887a0be2e8cf39be4a819c32860e7addc5f3851aee4ace70eb2de31"
    sha256 cellar: :any_skip_relocation, ventura:        "ce30f97cf887a0be2e8cf39be4a819c32860e7addc5f3851aee4ace70eb2de31"
    sha256 cellar: :any_skip_relocation, monterey:       "ce30f97cf887a0be2e8cf39be4a819c32860e7addc5f3851aee4ace70eb2de31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151d4abaa1fc17d7b26248752c475d0b2a08a73b75df66cc8f14e653d48e7f92"
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
