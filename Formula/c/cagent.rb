class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "1dea991de693428e924b26eee63c960632e919b0400294bbecb6b68c277a2238"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e6c37e650855e78e03ec6403a1f03b3e81b6f4c4c1b8d0051d1fb497204d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf51da8d3a2025b02bc53e754c47ffac88e03d8c3b6461608b7d5433a788176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bbb58cc57c61305d6cdde064482782d06309e1e3669dfac3374f1a5e088aa94"
    sha256 cellar: :any_skip_relocation, sonoma:        "9caf3688ee1dd2db00c629ed9bbd6a0886133fa2d339ae379448e3c50d87b8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99ab8d7adcfa70c8b9ba146f3847f903d15d8b7d5a0b5c555696760a5a0823d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17787e03e18bcf44f70ddeea57047cbfdf86709cd01d1e6d4f2f61042d23889f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
