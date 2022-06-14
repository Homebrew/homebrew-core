class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6870cb8c47897f2a75abaf3e6cbb160989b4e915b86fdcd9322fb17e073ccd81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd5a983a798ad85baf7cee7beef8031802ce9d3be1bebf9f991acc8a5127b441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22b39d62482d3695c533a2d4895ea474ececfc93c72571fc6c7d9524a0a58039"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab63f8075cda3f6608a440639773b8547fe2b9c83b95df7fc6d72cd5b6a0986"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e653084902479ffb85a676e85b54db0f8a90e074f0d4fbee717a8e6227dd636"
    sha256 cellar: :any_skip_relocation, catalina:       "e462cefcadb5ad26f0280c3b073ae56049b543ad488f46cb2836ac0eb66c6f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab225044ee4cde5b55b6dd003edd8eecfde151d03f5ad2a7fff0f3e07f3baa4"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
