class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "0a7670f570c6a1af22b6faaf3bb71d7551b6e2704eee130e2bf6337483b7061e"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0043537a1a4ec8184c42b960ccddb2567c47d088cff5670b46657cc76b7d4275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb360d9b1c334f7ecae05bcf7d03f0d1fb6d225403faf1aea45954a51696aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e291722f7788b1d6672915e8efcf48f0d451998e7518e76e98c3a2dcf89ae987"
    sha256 cellar: :any_skip_relocation, sonoma:        "276a410b43fd4d4cf5e2cef851277f9ed4fbc2b03c0223dfa5cdcde7c187d08e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164feefa85d256725ed777f466a3e79e14c52aa1edec7dbc579887ad5bf37760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcc6b8c84fa4f2c37d149e5ce51dd5a24b8133f7a4bc23d2f59f256da2c09ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
