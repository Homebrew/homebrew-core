class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "ec30d398459896650565bdcfde6861b854ccc38c0972302f2b7424e611ad29aa"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c142ea17945d9873218ef4865c093b5992595af5cc27828bff3c3643643c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a5aa7b5e52e29eeb903cf222e917a86ab8ce9a40036c63f26bf73eaf547ec5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dd7e38f114a8ab14ca73f8e7dcd007b8de02c517e103709267f3fa3ebb889c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e58d6c03921b90f766c38193d73a0cdf185be0a2aa4db362a2a671f9db8570"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf8b6c02d55edc6387d287f40a7b42c1f69bdae8c0f0ae7fa8745d10b1aa442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e0e43a12fed5731f325b844f3d0e0037801a67b126cc71050fdb1f45276046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba24989141866dc948ad3410402ae6c5f11d95db0474947bc8c20c50ebf73f14"
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
