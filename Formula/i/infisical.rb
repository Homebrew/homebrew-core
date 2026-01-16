class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.47.tar.gz"
  sha256 "72668b94e9a86ada7716c24ee6403b149d43abde97f3d835e635b8cd36eaf4ca"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9667d8ed9ef4b28b236def04ed4191105e2712e2e8f74c12f589db10c788f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9667d8ed9ef4b28b236def04ed4191105e2712e2e8f74c12f589db10c788f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9667d8ed9ef4b28b236def04ed4191105e2712e2e8f74c12f589db10c788f88"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7344faa364f0a15bd3ae3d7feecfe3da0138afc6bcd6cd316358db7ae6b147c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d0f47fc677c40abf9123b85f2b1af796e86f52f7d1d8de8cd599a0f1fab99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0666420c12ad58d17a3b507e53ab0b80f55ba72f77c99d9e415689c8d74bb01c"
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
