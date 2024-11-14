class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.108.0.tar.gz"
  sha256 "f31e02f264658c23b5b8101c1035fff6cd994252580cc0b0572fd864976896f1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f5a7e370fe6b6dfb175402c9ee446c2f3b68107d7cdaf1efaaeeb42921445a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f5a7e370fe6b6dfb175402c9ee446c2f3b68107d7cdaf1efaaeeb42921445a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11f5a7e370fe6b6dfb175402c9ee446c2f3b68107d7cdaf1efaaeeb42921445a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d003e58912097148cb0763c1df07f77c2e4a477c6ff528c9643d43c4023e1a0"
    sha256 cellar: :any_skip_relocation, ventura:       "fb64db61fbc1063e23a378170f6adacbbed4818714ea0b2843d63406ac7bac9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581646b2a1b27d6ee3e2ccd4e39f3bb26ec4737170b751c505bbb4776177239b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
