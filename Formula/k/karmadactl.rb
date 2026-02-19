class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "fd46ce59ad8ce8ebd6e0e6d5395b000b2ee2f7b69c75143c971e8cbe4292672e"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6322185f05028c7228f98d7f1595934ae812d82b64db516c4b3a51c6f83152a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd6d20e3a618e373daa826a6858e5b01ad76f6a08bc3b3abd96e5958c95cb91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb72481394c7caf26c37723adca1add45a608e7d7a5800346dd102b87831448"
    sha256 cellar: :any_skip_relocation, sonoma:        "159c21e597a3d46d2861cc762da90d55a7d6e908353f155ea42bee467b4e0fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cadbb9793430d93b788678cefe4336319382d551b6ab9400f3a77f4c0daf522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47c276457e46940f751e1c23c9d442e1fa7e20c3036f686c27943011a336b6d"
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
