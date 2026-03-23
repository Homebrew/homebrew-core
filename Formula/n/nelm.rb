class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "1943da6d11374d9774fbde69a8bdd8e373ea77d13e0f191897250c3700067ddf"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acfc87de48b45b7765396e3cf44a175b7826091063622e00ca3a98dee9cb220e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ab019ac135831682361b764bd3ad088f670827c171a6b4ac98ce684210bc2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e42d716e3c869d69c601a65f94cfe72426a30a59856b5aa922669d4b00e4a04c"
    sha256 cellar: :any_skip_relocation, sonoma:        "65b788202036eba45ee320cf76b7bc392850dce8405c796ecf74161a6a5c3955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "768573f69d36d9592ec10e1ced4a57da52e8f4b364cd3c60e75dfa92f07bc92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b524e0b66f3fa21d0ade17644d03bf2885310bd163344e86948bd92c86229461"
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
