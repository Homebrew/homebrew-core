class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.329.tar.gz"
  sha256 "82dbed7d2bdce3174cccc258502c21a70346b8bf62570dfda4796415a615a0a0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39c09b0a5766b194d6cf0d2dd4f25999719ec84222e763c3866353946de2461c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c09b0a5766b194d6cf0d2dd4f25999719ec84222e763c3866353946de2461c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c09b0a5766b194d6cf0d2dd4f25999719ec84222e763c3866353946de2461c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7325d4739eee4e246eaf9494281d24db57b17ed8de69f04aba842043af95f12"
    sha256 cellar: :any,                 arm64_linux:   "ea9e09e0e5458bb5c4b13e70bf8ee8a379d1dc331246ef097edb61bfc2427589"
    sha256 cellar: :any,                 x86_64_linux:  "9ac437904a994245c39ea1f537079cdf978ac676aada45ea4e2ee0946419fba6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
