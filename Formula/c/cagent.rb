class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "2ede2518180892ef140866495e0854076ca221cbafcdff35f212337430b2699d"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38424309950ff3482a3de1d6db74625daad9ee85bfcc17619fa2d1cbfb8ad676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92affd3ffcd3660a3a743febc5b4d56ccaaec11b42d3f2f555e3c79239402aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "654654266151a72aac2622ad5cce9e60fe9a4c2544b7b8a89d0cd9f2ec65bbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c0e8b0e9267e9d0bd476a63148ff0bf3bfe2c32a1c4fc0c6f96e486e320f05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed0d56e178988e993e7f5c3ba31e4bce0cbb48ee1f011d3d6fbf3ce36e18037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18708e76a7436f2891d55441b042ad60c5ebf9dba3e72eba1718d740be796596"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match version.to_s, shell_output("#{bin}/cagent version")
    assert_match "OPENAI_API_KEY",
      shell_output("#{bin}/cagent run --exec --dry-run agent.yaml hello 2>&1", 1)
  end
end
