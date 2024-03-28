class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "a578453e654c16a871ed2923dbc31d7ca3f84083a62106201d89664ba8072133"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05b7add5f9d11bad95e37b38274d77e9b3e48f9b96666d0bfbc63be82f3118d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee69d99802c6581c29afb98ff61855dd84c4e2975ff2f7e71cfdc7c9a08a8ba8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ce8939c7ed7b9fe3877adacd564616df628d9e6a59625f563f4fbe76a78bc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7daf4418bb4acdadfe9c24187caffcd265dc3b6719fe81302d4eee5b5cf37db"
    sha256 cellar: :any_skip_relocation, ventura:        "922b504e0c3ec1dcbbc75f6e1b9465aced152fad1ecb0a4c2864f9a407043a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "39f7cdc6803ea9850970c51af601b0182dcccb88c52c3e61e5e0a164887b3257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba43d38970ea0318ec98ef7628fea6819af34c458ee33ce59062dbeea3ca3b1"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
