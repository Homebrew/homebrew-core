class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "816098a2765d230f71fa794bacf5ec36aa196ce29cb3d828d01764d1b88777f0"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f83cb068a37f12b9fac95fde411adbd0f196a43aad95fe68511a8e668b6dada3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0937b4c6d132542875bd3a8b81129d5f50b9459a0093491ffbfa291f329a2373"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65065fe2a1e5e8c4b9ed6eb684f9e5469c7e5e3119574b36141f0b0f478cb27d"
    sha256 cellar: :any_skip_relocation, sonoma:         "81c8e38a853b9ac9b3042b8bf59c03fcd7bf03c57e5fc926f84b11ed8be9ed9a"
    sha256 cellar: :any_skip_relocation, ventura:        "1e488fcd17558a31212cfd09eca85db965c87b82f3eaf7a282d5454949b6f036"
    sha256 cellar: :any_skip_relocation, monterey:       "1db99aea6646c8f62aeaf243185ff7be0bc92c69cc427ed1cec1ae64e6b487e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80da2bf32f1687815eeb1f04107817bfd43f61c95fe214ea7f508971c28bf885"
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
