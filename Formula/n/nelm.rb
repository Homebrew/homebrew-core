class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "ee9ec58db1a6e273a06eef39419ee2bc8c6dfdee32edab3bf3093522d3d0c86a"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc978fbfba8b6867b55810a8d862320ad1141202a57d5cd82205b4ef8247e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716581a435bce9910df92cde2b291c0302976a458316590eb3ccbb7a0fc7a266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d994ca0a5c771debbf32161f7d644a0c62380295725b1dc640aa19efd4f84d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c0fb47f5dd12e13e5d0c71c1f3967b5571031bf7701f0b8f0088e11c4b7283e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db256bdf16c20fa5f596bd453ba2444a61609a4785a2b28636c9860e0d24766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efbdcc9ad7cde530387ef9d50bde9f19c16d45c524028290e6fdd428cd643afa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
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
