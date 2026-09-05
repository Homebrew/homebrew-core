class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.335.tar.gz"
  sha256 "e83ad16639f66d53814322861b1db9a2092cc717c7f41efccda057e1c52b2319"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57f162e666b0f6c2ddc7b8eea3b048f880611f30f01db09cfdae1e5b1eb9ac0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57f162e666b0f6c2ddc7b8eea3b048f880611f30f01db09cfdae1e5b1eb9ac0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57f162e666b0f6c2ddc7b8eea3b048f880611f30f01db09cfdae1e5b1eb9ac0c"
    sha256 cellar: :any,                 arm64_linux:   "19ee76d2bc0d7281432d251c2a4ee9df194c3325cf876625e7a687cb2e48483b"
    sha256 cellar: :any,                 x86_64_linux:  "0fcb87b62e2bc10621206818494c29454946cdff1d54323e0a2ff9a84b77d77d"
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
