class GitPkgsProxy < Formula
  desc "Lightweight caching proxy for package registries"
  homepage "https://github.com/git-pkgs/proxy"
  url "https://github.com/git-pkgs/proxy/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f61c0674707563c9e6f2865c0ac17a0bc423c7998dc6e42fafd37db0cd39be72"
  license "GPL-3.0-or-later"
  head "https://github.com/git-pkgs/proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2c79b3cf0f4eabf0965232d474021b33f2a397f65a34e3ad9d6cd3eb94a591"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb6ad74677dec0c8babcb57cef700ff75b3ae3371819dfe5301ae68da0d6aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fcab8723d5615baba761a9e1f818f21ed219713ca9489d79e1219244fce5d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87019672e49d709b802975782828c8243659fb12ed6d8000566e0973a592e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3838f5dc0d26e53f1caf1d8c2eb02d47ad5c01fb2eeaa844e247cb8b8c7d766"
    sha256 cellar: :any,                 x86_64_linux:  "4aef56ba880d0f841050592ca9a5a3a0e95832e33d9b9e7c781878f7ccb7c82f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"proxy"), "./cmd/proxy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxy -version")

    output = shell_output("#{bin}/proxy stats 2>&1", 1)
    assert_match "database not found: ./cache/proxy.db", output
  end
end
