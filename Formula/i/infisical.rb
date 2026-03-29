class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.67.tar.gz"
  sha256 "890c30242fb080e6e6bd69b485792e6a2f70d51c79fe312bdd0c83ae7ea4a17a"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a47d28d4e299c5d8a9ee2eab5877e8c6acefdcd424310cf8c66ef91ef0ec17f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a47d28d4e299c5d8a9ee2eab5877e8c6acefdcd424310cf8c66ef91ef0ec17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a47d28d4e299c5d8a9ee2eab5877e8c6acefdcd424310cf8c66ef91ef0ec17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c7427f8276687c4fb7e6ac79343f427051542783377fa2d0e12607fb0f36f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8de5c9bf4230619fa49f180e10f21809bab579fd5d66bf9f5fce1f2f87ce9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc4081acdba6449552c03e15d805a17f742ff3105522d1c5d9a762dc32e9ca3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
