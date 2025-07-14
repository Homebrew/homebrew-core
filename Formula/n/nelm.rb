class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e832a4a33e8c00f0d4ae04a21b5fe8e8d7678e1201281e2bde12a7c40ce4db4e"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a959bbfd4a30cd900d14d118cd0bd4e33f2877c0048ddae1189dbb02db80ed22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b071f473bcd895ab2c46a91269b19775e1cab95f2adec82f460bcfe7a7eae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2db8ffd652488413d9118d0f1d38828e4a493c19008cc13b35c1e3dd99334fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "28eac62cdcde402b9cdfe501501d8a19904c12dac6907b525f9d3f353f44cae4"
    sha256 cellar: :any_skip_relocation, ventura:       "b7357ef12b6d7ff6941bc4f68ee0f3ab643a0bf681953128614df2596a2e1611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a584c6faec64ce37b11a05ead3cc8cd295bf5ee40bf09691778432b970e29775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efad67bd3c5f707fcc9c35ef6fd342c092b9d8af1be98124a7b0cbf01083f478"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
