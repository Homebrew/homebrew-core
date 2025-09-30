class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.5.tar.gz"
  sha256 "79b28c5e40ca745fbd8098384b9e93afa799d67c6518f7a82875d51418648bd8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6793f587a62600d62725df07087a93b4789b10f738238a290b8d080c914e5a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055bc55e0a462c5d9421076310bc5793d186a0526426e25f018850636671f5d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da5b7ed429b22ff64ad9e415e75844bb1f4ab2df6f16696e35b674432c66d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "669e3c5156199b12b3d808670dd018930ead3b6a42f3eccf55390400252562da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e0e1a3a74888bef1c184c160762d67d8be9e72231edc5fe97e4afe5c7654b9"
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
