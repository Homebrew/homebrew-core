class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "2c1021f1f2da904e87f67f90e5c91171ca76d45a3b77f9dbe816597b074aa79d"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "345c5aa04a6d31615ce846d94358acab3f50514d2a58ba44eba205e8f3ffb8da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453ec7553d0b52b49849cc5473cb5e72ceb2be7d4179c89465843ee969c27179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b863ab0589967c748d07737afe9d3313372643618c88ac45f52704d29cb945"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c907efb6571163915bf7db28c06aca77191fd6c8c588eca59a04e7844a8d3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455dae55238d6273e861f6f7e7a3db1494b1d43ee5d6ec2193e5fadb15d6a738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7666b44bd6aa18bd9d8a6ece604b2185d1f6650ba3d3f754310b983c4525bbf3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
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
