class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.169.tar.gz"
  sha256 "b3dceb0787fe21600c4dda071a0103ce2d82292e4826d66d5f3f5fd729998d1c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364536642a7565d44678c87eb4e6d11b05da5cab7e8676403bf87e6500a091fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364536642a7565d44678c87eb4e6d11b05da5cab7e8676403bf87e6500a091fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "364536642a7565d44678c87eb4e6d11b05da5cab7e8676403bf87e6500a091fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7108ee2bcff5d46a93b4484d6c34a0dbd539aac445e65b83795817192693730"
    sha256 cellar: :any_skip_relocation, ventura:       "a7108ee2bcff5d46a93b4484d6c34a0dbd539aac445e65b83795817192693730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf612b3c3e7da11106683d37c3bbec4427bdf82495ee254f46ef538c0965d29c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
