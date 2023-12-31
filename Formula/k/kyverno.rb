class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "69abfc8cd673cf41b6c202bc1422b3155525270eeaf5a4c0d9c58d27be8b84d3"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb7c0568785a97af0fc6ebaefe0faeaa3ed596a4f03b965745aaa0630197719f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8d5a964c5b26b3cae9c89f843657013925408935371ab0e7acfcc6eab8af50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "742f4932de5ba549cd82aca790b1d04a6ac55a45ad9216b457617216d727ccbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ab6f62cc5bfbf50446e2e44e1b0d244e4f2806b806aadd13ab12837df5766b3"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0215b6b6f44d49f2657b67cbda36554c58527842a174451f913cba1547be22"
    sha256 cellar: :any_skip_relocation, monterey:       "9eeb138bc807a0acaeaf570bb82f606d70aef06d2dab03262369951146dce643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379394d3730e088007fee87f84522ad6ff0769fd21adfc8615c4aa06c60ff372"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
