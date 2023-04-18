class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.217.tar.gz"
  sha256 "172d190b2d87a7ec3dc3e6e68366a326d1a399f64fdaa57f1518211f9cd78a7c"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4d85aaf16ff7f77da4036d0e66bb383d638ef22d3c583140d1c40b009db5a8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "377ac9cf1e02e7e26e375ffc276c0649822da53ff7adcc89e076f9cfd6f906ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f533f308a4456e2655dae28e5294e5b0a07d6eebc8d515277241e49ddbd86e53"
    sha256 cellar: :any_skip_relocation, ventura:        "0ebf653317a14357a2cc56fd77b444d10802ead4c8f8917c201b885d4efc3d41"
    sha256 cellar: :any_skip_relocation, monterey:       "be8db29d4c882a299d4c2b14a654d8a73ff7390d7fff9120a3aa2e9010c68ddd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b2a4340839d1011fffdcc6ee594354ed654f1dc318591be885a9979cd0182f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4a0124d4a1fc4024c8bea04249c32769cb1a966610ecefe53ce2df12e72d80"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
