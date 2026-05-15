class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "f00ee6ca3f9928d6c569f61b9862324a14261c9a36b3c78c28ba57c4134930df"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2b7b2885900d397a14e765556a6aeb51c9f6f4a3ccc563a120727f0b36af9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2b7b2885900d397a14e765556a6aeb51c9f6f4a3ccc563a120727f0b36af9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2b7b2885900d397a14e765556a6aeb51c9f6f4a3ccc563a120727f0b36af9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b8fe2c47b3ec75565092743be6a95a8620a2bf89ab3b06ca8dffe8927ec621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aaa89da3a0114602f4ced8cccbb803fc0ddded0c75948c1031bbed2965c20af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee20fa72e861b3e2d6ab3d5be950ec08f924d335a81339b9f4807468d8932f5f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
