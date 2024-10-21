class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "73f6d7e9e9b507425b8c58101e6eab933aad27372cc531ffd110e283a6ff2d3e"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0224be773cbc5ad5a8963a64f453a34c41afc445e882f8916460b785dacc4477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0224be773cbc5ad5a8963a64f453a34c41afc445e882f8916460b785dacc4477"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0224be773cbc5ad5a8963a64f453a34c41afc445e882f8916460b785dacc4477"
    sha256 cellar: :any_skip_relocation, sonoma:        "85afa669459e2d6ed3d3de922bf53b552c1a8b601601c8c817c08e2a664ac6b2"
    sha256 cellar: :any_skip_relocation, ventura:       "85afa669459e2d6ed3d3de922bf53b552c1a8b601601c8c817c08e2a664ac6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c9c04e318f31faf936ed3a35cfcfd352e2c379bc7b1d1f99f6d138ca631190"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
