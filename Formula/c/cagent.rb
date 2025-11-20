class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.9.18.tar.gz"
  sha256 "3a3fea47f1e541b0e3a79eb78589b92ee1866dd36691beafb80e5755ea2e61ed"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd37859bc109fe8283319a343e3c2dbc0de3dda731abaabfa2ef336dd1798c5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd37859bc109fe8283319a343e3c2dbc0de3dda731abaabfa2ef336dd1798c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd37859bc109fe8283319a343e3c2dbc0de3dda731abaabfa2ef336dd1798c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e2e3a64733e15509205fd77f1b75fb1991b64a09f7bd5f6e813c4321d449d0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b39e6d6d06f115fb17185b9cbc7f12f1e4a062fca730c83b23351c97c274e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd54fe740410722f8488d0cb7c27708f3cee7133ac081b65258fbd26a9045189"
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
