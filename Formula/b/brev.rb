class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.334.tar.gz"
  sha256 "3b329b1e4689b1d17f4ccde79859a10cccf4bfe0d59464c15d58c445169a0465"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2e45cb7c9ab5213168d78f1d2ebd1d6dd7e7b7fadbdbebf7f2462e5f21c95e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2e45cb7c9ab5213168d78f1d2ebd1d6dd7e7b7fadbdbebf7f2462e5f21c95e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2e45cb7c9ab5213168d78f1d2ebd1d6dd7e7b7fadbdbebf7f2462e5f21c95e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6330cd5a7c6ed1d1548329d3a46ca9e0b1b0ee8266b492a800fcb6ca74b6bb85"
    sha256 cellar: :any,                 arm64_linux:   "725885b3b4e68fa5fa5ccb383d5a39161245bf9c266dce42a2ea57658073f7bf"
    sha256 cellar: :any,                 x86_64_linux:  "83d1262f01e59a6d1327212274f4cc9e358947b5e6abb19cdf8ae8ad6d5142d8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
