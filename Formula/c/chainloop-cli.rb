class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.136.1.tar.gz"
  sha256 "18b0cf3025b98d6259d74515063ab078f467c5850f8edfd8b08c60edfa5402b7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef00458c83eae0eaafacfa00994f4e0d579c0ebf06b574ae5fb1c1b7b4ad55c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef00458c83eae0eaafacfa00994f4e0d579c0ebf06b574ae5fb1c1b7b4ad55c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef00458c83eae0eaafacfa00994f4e0d579c0ebf06b574ae5fb1c1b7b4ad55c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0ea3f71a2cfa2593322c3a99e3c4b8dc8d7d7e6f92abc97ed27aa3c390f15b9"
    sha256 cellar: :any,                 x86_64_linux:      "b5de2acc3196202ba3bbfbd78c0e8d2d8d4a13e42c2f1940cb62ee419c1eac14"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
