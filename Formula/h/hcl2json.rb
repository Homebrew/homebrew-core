class Hcl2json < Formula
  desc "Convert HCL2 to JSON"
  homepage "https://github.com/tmccombs/hcl2json"
  url "https://github.com/tmccombs/hcl2json/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "577009829cb3de548e1ae78f9b934cdcfafb1b5b1f3d5b2a62ceb1f6d88fff62"
  license "Apache-2.0"
  head "https://github.com/tmccombs/hcl2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f8933bbbcc345a06385faf3e07da39594c23a270beb4934aee6f280baafb76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec9a49b460d45145f06fd5290eeb0e728281e98ef0df96020014a77a224ec4b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec9a49b460d45145f06fd5290eeb0e728281e98ef0df96020014a77a224ec4b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec9a49b460d45145f06fd5290eeb0e728281e98ef0df96020014a77a224ec4b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "58c08e45591dc30fd763446d41470b5dce12ec5f7ff9ce0e170972174fbcde77"
    sha256 cellar: :any_skip_relocation, ventura:        "58c08e45591dc30fd763446d41470b5dce12ec5f7ff9ce0e170972174fbcde77"
    sha256 cellar: :any_skip_relocation, monterey:       "58c08e45591dc30fd763446d41470b5dce12ec5f7ff9ce0e170972174fbcde77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbdd19b10ec94ff8c93405c4d482969548f8037d698e460266cacd1fb8230b95"
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
