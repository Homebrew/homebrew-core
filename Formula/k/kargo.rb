class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "2e1112df981a78636056dbd0ad644eb00dcafde46d1f2756948288ee28dd8962"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a71f6e8918ecc302b74f5a449fba47d3b0ebc60797cd4ec4d51c5176a791bf99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08c38769de9e09850ef69a199c1b6d9c71a7201abff36f1b15ee55361afc83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f103c1ec024ccaa3531fe563d2b7de9a9ac3b55b1655be5d8edc9cdc126a6dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3498fe2bf4f836e265bd3f6e896aa72a52b99ae3b60f51737ecbc6fda1d0ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e0185fae1a5891a5b9c89306d159d37ef585c3a82a65730a55c6cc2ec13020"
    sha256 cellar: :any,                 x86_64_linux:  "590b6666e5698dd5ff5b38694da0afb3abc7012dd36269114396bedf6213b79c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
