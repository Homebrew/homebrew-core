class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f07979deaed1e8cdf8fff2649a1d89d6ac6986e4142ba6553b09e6e919b5f094"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d882558bc56adae59c772d943045f19bebf546c44412449fec72093914eed461"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e32a93392c91502366584cda7a41421df7dbdde789e58d55015acc61d40dd5ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a3c6c245216992c7c62d6abcc2769bf1c80b69e235a6b25a68207b7e80d7da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa2c56f83110e9e9b54315cbbd4ffb2909682b8de80e73ef812873771c4b536b"
    sha256 cellar: :any,                 x86_64_linux:      "a4a889f7e0f65444607c8eb0034dc4b07fa07ab47fc8a80737cc705d3830e0bf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
