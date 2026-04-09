class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "72fa77156859a34e7a0557ea992f7c72d793ec5666fdfc2888a5894eccbfe14d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be5ec3ae10bd9ad9e80317ae07f5ae5dbe184196d0e2ca99be8e05740fb947a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1fda5a0bb26639746d9ccbcfbc9792f441f9c955d17779149325c2acbb5e9ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23420de122720c33159c2278094f89d11d93b8fd39658826ff935f3b90df3514"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9c3d4a821a38aa44baed343029624a7cb380e14432897cea4697e9a29256c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c894cfe909aadd8f7d50d0ee1654ca7f68bfc5dfd8ab004f269acc13b4cb0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5bf4d12a0b9bc9cc1997ca16854d637f281658b0a861dd5fc6beaf39006dec7"
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
