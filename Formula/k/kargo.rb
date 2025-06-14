class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "1858543bf72bac4abb301a3b015c4e3586a9f89899fbf797774408cde4d46539"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1158d5b7cd7e6fe6ec8a867ca23ed68d84e43411ec13e24b15667f31070faa26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9413d3bc7a22ea28745e59f87ac2ffbcf5994df79308a22549b079d36873a2e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d6465bbb8af2e6b446d53511fa2670619c77df354a4aedf83b58051ea8c3d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15d77d7a4e495f286128992aa0237c65347dab0699d76a13744e67af34b39dd"
    sha256 cellar: :any_skip_relocation, ventura:       "2c646ff0ef60eedd02c7379ee4b8bf4f9e2617231883085cb6b234dd901baff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "537751bea1333235e5f891446ce529a4967dc2a1ca46fbab262a30bc5d7924cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bf1ecd47476767c38c7e9d0ca8582bcdbee7ffaf601922ef2ac7556793eaf5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
