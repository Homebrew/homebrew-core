class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.9.2",
      revision: "4dbffc57a124d14e681874b9839a8c14a41edfe0"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72e44ebde0a97c5fa604f2b836962d550d8db2b9542d7bb1c87a89066411eaa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc07c152dd9a808a4f55f42efbbbe4b0cc3352a65901e1b2cf7f8295bcac440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f5e5318b1e8df8ca57a44b1af7e87dc2a5d301edbb91dd4a122751a881995bd"
    sha256 cellar: :any_skip_relocation, ventura:        "3e360fc3590757894d5f349b0184672649010fd21b90860339f7bc3692be98ec"
    sha256 cellar: :any_skip_relocation, monterey:       "10a7fe385d046baf79b6c76032053c0173ab251794ecaea8bbfacf23dae19c2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1479fb3475a74ca10873a8f24b3f99d2899d8e97483529fd1e470151eff5e981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e412dc1968b2456ad993574c3ea9d24cdbae8af17d1b81849e571f0d0222428"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
