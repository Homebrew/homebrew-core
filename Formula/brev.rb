class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.148.tar.gz"
  sha256 "e9669b26c8e50a2fc5e42145f1607dd47b26916ae732805029a59785bfaa4ced"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd473e2e819f049b471b8a53dbe0556749471691feb83b131229033b12e24dff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7a37ce29e3417e144e7b9373c3e20418ae8bba3e365fb1e5e790c09b0293854"
    sha256 cellar: :any_skip_relocation, monterey:       "8fcf621a1f78f5dc363394e97b0e18679db0055a2b2112099509d4ba17256f9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cedbe44dbc8b40df3370713406e00f3ef4968821233cca7b70dcf91fe7752280"
    sha256 cellar: :any_skip_relocation, catalina:       "75989ae3d4939ecfbd4bcb9731cec04d79a41f2b8184b0ef11d72200a3568915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e7a882c178e66e12214ead07b2ae196ff75fa2405ff47b0b3246d33ee6d87d"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
