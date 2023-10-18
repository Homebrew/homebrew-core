class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2ec33271f1e332329bd112b8fa56e05434ec61d496a3950934782b1d21c4a26d"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d353ffe2b15c95d877c0838fde36840f45ed5f3d11bb570cda556e66112efa95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd4d6ba11a2c8a467920a0ece7796a36251babfd0433da82a6af61292035d45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd4d6ba11a2c8a467920a0ece7796a36251babfd0433da82a6af61292035d45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dd4d6ba11a2c8a467920a0ece7796a36251babfd0433da82a6af61292035d45"
    sha256 cellar: :any_skip_relocation, sonoma:         "1edcc690400d8c8b29479c1473632f0b82ee0f84efb99af2cb2485777c3b4b56"
    sha256 cellar: :any_skip_relocation, ventura:        "9a013efd58dd3b6faf647f8c7c02180ece99d1125c7c1b530ff5522d682faa45"
    sha256 cellar: :any_skip_relocation, monterey:       "9a013efd58dd3b6faf647f8c7c02180ece99d1125c7c1b530ff5522d682faa45"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a013efd58dd3b6faf647f8c7c02180ece99d1125c7c1b530ff5522d682faa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be0b345e6e5736d86ffe4823a513a99527f57f378ce38d71292e87b69303bed"
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
