class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "4e7419d362457fb606c676601b48d66d903bb05818136960d06a7834557848f9"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d32d4a460631e29813a0bb8ae2be55fd0b66ee911791bb3cbe287feb4f7cd4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7c1cd380b400301a386ab302c20466d1ea85d1ae810e6490b5f80e13de6752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f987c98e78256d7a4f855b7f8eaa69b8fad565e7da822af73c5628753070eed"
    sha256 cellar: :any_skip_relocation, sonoma:        "097f9f48fc038f07f86191541e4587e4cc874fe9df1b2af80222df3eaff0cd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd5af99d499bbff5d5ec868cd15672e4cd38fac10793bb62f2a4b4bd4a92961f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb4cca9480c7c65718914fea406a765c4f1ec4f206c36fc3de29b8c1380f9ef"
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

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
