class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://www.brev.dev/"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.295.tar.gz"
  sha256 "49b945ddc8821c129eea946bed4b17f4f3ea96b4036a4c8b515a39289078a26e"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "553cb271697e2ac2ea1e9f5379a9ce0f9ee661d718597be943ae12c8b6477fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "553cb271697e2ac2ea1e9f5379a9ce0f9ee661d718597be943ae12c8b6477fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "553cb271697e2ac2ea1e9f5379a9ce0f9ee661d718597be943ae12c8b6477fd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c120617c222360483dd8bb49acbbad894be4257bab2d7926e49e1933eb234700"
    sha256 cellar: :any_skip_relocation, ventura:       "c120617c222360483dd8bb49acbbad894be4257bab2d7926e49e1933eb234700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b62ffb71d837837096142c267cf147612decc1c28787da25b10fe36f5652da6"
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
