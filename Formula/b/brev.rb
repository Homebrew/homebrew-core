class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://www.brev.dev/"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.302.tar.gz"
  sha256 "7884bcd00ee288ddd517f3e867a58a152ddd02afdb9c49e545ae0a2a0b1e02d9"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c670b5ea864522f59aa65e3ee5c9a1051adde82b865bf7b0ece62cba6cc3fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c670b5ea864522f59aa65e3ee5c9a1051adde82b865bf7b0ece62cba6cc3fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64c670b5ea864522f59aa65e3ee5c9a1051adde82b865bf7b0ece62cba6cc3fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc21b19fdde0c6d0b5700222270ccb593587079e2f0cdd3ceac382156afd5154"
    sha256 cellar: :any_skip_relocation, ventura:       "cc21b19fdde0c6d0b5700222270ccb593587079e2f0cdd3ceac382156afd5154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0f3c683332d01d0b41973c3de810fee5a0d0e502bb5c76882738c5b49ddbcea"
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
