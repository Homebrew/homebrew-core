class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "aaf4870c8b64e4c3a3fbbd3a6650424924e5dac2b3a9900ce7b96f89905a751b"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20384d59e998742f5cd6f428188bddac97b7a65631180510740961f05c2e150e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20384d59e998742f5cd6f428188bddac97b7a65631180510740961f05c2e150e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20384d59e998742f5cd6f428188bddac97b7a65631180510740961f05c2e150e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9166e69884021e3c86bae6d3bbf987b07974716f7206373e442103897000b75b"
    sha256 cellar: :any,                 x86_64_linux:      "84319373e6fbcc15a3b259c48029aaabbbda4418a8051a6071725a12e7844fc3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
