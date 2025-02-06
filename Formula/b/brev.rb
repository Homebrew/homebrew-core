class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://www.brev.dev/"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.304.tar.gz"
  sha256 "025a37b61d439b287da4f5834573e63f408f5469190a422defab58f2382065d5"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4567b774e4989800709efcd689b47ff67849644d227e6cf0fc5e6b2a0cc59bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4567b774e4989800709efcd689b47ff67849644d227e6cf0fc5e6b2a0cc59bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4567b774e4989800709efcd689b47ff67849644d227e6cf0fc5e6b2a0cc59bc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3c97ec81cafca112e1e408e8eb514418eedb024771b792c7a9643f3f6e60b3"
    sha256 cellar: :any_skip_relocation, ventura:       "0f3c97ec81cafca112e1e408e8eb514418eedb024771b792c7a9643f3f6e60b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63015ce25dc869185f886853eec37eeb33300ece86b28b6830f8df25e66c8df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
