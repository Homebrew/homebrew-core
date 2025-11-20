class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "01d660062f5a6be2f9b5cfbba6a6c1ddcee00ac919f27b9495e1cfaa6918697d"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a5780b5e39ec935eec907cea8958d1a31332414d08829e73fa5d253acf83a1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c611494cd0949130f417b5f4bd4722b83c67a8a3d7b890850fced0fe7f257c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30421864f334b04c3053e14afdca8567b9be622875706ecde0df51dc088af36"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8d2a8ed77c6f255463a3d7c212b9001ea83a5af73b7916809347f409407dac2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "212ed92ba8e5d9c2e00383dda87f6e0e7e1450c729db1a70751646344c450f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404cca28d48a0061507d16d5079303e362850c7fea54d9f51c6ea2408cb8f443"
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
