class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.8.2",
      revision: "540f133fdd1f78d394a2ec31658361b9cdc57a33"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aa6679bba87edeb102923f51ae8014b71adae26cfe942fabb74e3afc9121c2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f78ab00fee254741dadd1ca4f1d8602f0dbb95b8a12db692e8bef8e249201fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca9f6d995b9ecad4184406c523189f455ae8bc44df0d0ac6fa645247131fbe3"
    sha256 cellar: :any_skip_relocation, monterey:       "318496a005217d9264732c275fe3063cf5f5834fdf4cc7efc31279d9f6903893"
    sha256 cellar: :any_skip_relocation, big_sur:        "abfd8fd774ea1978ff8c7503e2c6af06e5607f24fef5a04d1ffaa0156d2d5873"
    sha256 cellar: :any_skip_relocation, catalina:       "3d299024d9e7cf535d54ca8758d6539ba7cfb0c4d8ca597d9b8b39f387c87386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e787c09c911d1dc592c1d3f2e2bafa66e8942b8e9099f6245e52a8c8448f70"
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
