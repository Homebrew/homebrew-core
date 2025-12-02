class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "d16adbb11be83edfff646d8a980e7bef1768b57120e5af35f37f70f97d0cbaa3"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b30ba0ff0a619c866f6295eef6d602ee27d8328f82f59b5677904a0fc9342ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b30ba0ff0a619c866f6295eef6d602ee27d8328f82f59b5677904a0fc9342ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b30ba0ff0a619c866f6295eef6d602ee27d8328f82f59b5677904a0fc9342ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3004b6816dc664bf886171d3ae22a84c998243cb244d8c3513b4377be9ba67b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f56f6f995984f2176c8e2081486b42f5dfe6c094668ddc618ef8ce1cbd495e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90d1a75d757aab2450357440b15d680f363a1324e83d0a383ce02b836e11d26"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output("#{bin}/docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
