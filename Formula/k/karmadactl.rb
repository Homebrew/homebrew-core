class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "cc0cfa3e42451e46f2ceda556516ebb5deb3d76da9585ea82487266f2ecf7ec2"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5db2d6b0027cf9ae914f16cebe9c503e97445f7442946084ff9877b6c9158dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "877c8f10fb030ec3878595431559713670f25bc6021180311a4586fa8401e305"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc21109b4fade5e0cc30eec2674d96541ae50ec7b218becbe988103c8ab0401"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c034d403ee067d644716ee5e3f7bf90af9ec1d79ad08580feec7f0961c1f080"
    sha256 cellar: :any_skip_relocation, ventura:        "8b180f63119121a1c45b6514acf1bacc39e628a2e7da78e59f8ac3f375272d11"
    sha256 cellar: :any_skip_relocation, monterey:       "961cd9839c3870c223ca82e5cf3b0f3a26568e4c5b302954e65ebcd55a17a823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66bea8f314d524c0e634f806df38aa47a0fa046db0b7df74a3dc3f729ff4e0f0"
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
