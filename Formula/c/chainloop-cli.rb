class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a9528b352eca86cc95a9ea75ac089e97597040fc4cd0b4d4de8b0199f1cce9c1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be99be6c9a9c141a005d13927256cdeca2d3b15a1339799a4fea710641adb349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07901bf850e4a73b5d862f8e0be5b41f89ad24b541112ad80631ed9ef7f1ca09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24488b074ffb67fd77f49e5ac3fc62f212fbd630999fce879eca2a28f958596f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6a66cb12f1736b8b31df10f3537a957f9dbd156eac3b5c4e0796809d1e77f9"
    sha256 cellar: :any_skip_relocation, ventura:       "58c56a06753baa99e684fb13ff483ef7537cd309c8eccf266dd4d1357c29d117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4152cafd7974f0e3d4a11bc8e0ea16046dada2f3168b60b76c297cf527703530"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
