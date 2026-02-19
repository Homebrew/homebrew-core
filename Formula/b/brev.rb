class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.316.tar.gz"
  sha256 "095452684cb08ffc3b94d1415c17ba9ef25f1355d4d3105645bdc6ad498e2278"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b03e0c6f35cee6c9429546caa7f234cf4d81823e9b9d7b3c70a7904202d63831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b03e0c6f35cee6c9429546caa7f234cf4d81823e9b9d7b3c70a7904202d63831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b03e0c6f35cee6c9429546caa7f234cf4d81823e9b9d7b3c70a7904202d63831"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc968faad45671c0aa786fba01ba18098901495150a287e24db32e12e4744f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51b6a9d8acc2a759a774bd5d4355f92e724dddb71296c371ef545bd49378e04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1731517e837c3949ca6ebe97b97e9adfe50090cde7dd6b96190064ee5a44e5dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
