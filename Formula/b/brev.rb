class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.322.tar.gz"
  sha256 "0e5d5617ec1397367cda5239bff686825b393744dd7fa45e2aa63f57303ea869"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53525d2d26fea160614f92bd4a276dc2e1981ebec5acf2d14655c1885b26abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53525d2d26fea160614f92bd4a276dc2e1981ebec5acf2d14655c1885b26abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53525d2d26fea160614f92bd4a276dc2e1981ebec5acf2d14655c1885b26abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde9a255fb41943b5f7506f0886650935ad7ce6df98f1d9c1291e93ea9fa41e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041af20790119656bf2b955b83055f997e6efc2b289d7b6cdf1b3392deaba957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e52012d6b71ab05c4eb9e14f740a4dd8b12ebeb66498f07131bccfb893e1404"
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
