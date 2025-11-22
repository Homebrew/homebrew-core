class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.21.tar.gz"
  sha256 "2e2d421af6d2746d7bb7437d728390a70c14dd92815d81eb08200788e3d9c552"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f51c9d688615acc331920daadd2b6a413ca5ead3b508543db2ac5f65e2626e36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f51c9d688615acc331920daadd2b6a413ca5ead3b508543db2ac5f65e2626e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f51c9d688615acc331920daadd2b6a413ca5ead3b508543db2ac5f65e2626e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "043c4cb948d60f3ef786b67263f5d538e1b600d387df4c1297481a22324e2d39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "785d893d2ac6bd3d651a1dd40e56b2f69456029cb0bde7609f590659d0f29fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f6d00473537d63d32038d3aad7462c6ffe8eabb9e415abfe37d7709e7ac591"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
