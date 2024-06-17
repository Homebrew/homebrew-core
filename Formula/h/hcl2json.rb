class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "b01d5dc02c7fc4806a0eab1bdd87d0efd8eb4f30e02709492c3b043e7901d835"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a341664a3f3e2d51a3caef4d0e1648ce52bedf68eb3bccbe80d7ac876625ad92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a341664a3f3e2d51a3caef4d0e1648ce52bedf68eb3bccbe80d7ac876625ad92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a341664a3f3e2d51a3caef4d0e1648ce52bedf68eb3bccbe80d7ac876625ad92"
    sha256 cellar: :any_skip_relocation, sonoma:         "28b7d8a4de5acafd782cb233a3240a45231923b6a2f932dd0219e12ac0bb2783"
    sha256 cellar: :any_skip_relocation, ventura:        "28b7d8a4de5acafd782cb233a3240a45231923b6a2f932dd0219e12ac0bb2783"
    sha256 cellar: :any_skip_relocation, monterey:       "28b7d8a4de5acafd782cb233a3240a45231923b6a2f932dd0219e12ac0bb2783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4638be888420eb151ad1e9c3f141dfc8feb1e5d2677f420eb5c55709fd94378d"
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
