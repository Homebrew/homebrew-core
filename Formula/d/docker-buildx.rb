class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "c20f30462818a4e9224ac8dbd639ff9da323ecf40f296095e5a693296ad4b765"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7024c646c4185557026886eaf6657407e0acf9ef67d3b6e06925feefa3afb65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7024c646c4185557026886eaf6657407e0acf9ef67d3b6e06925feefa3afb65b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7024c646c4185557026886eaf6657407e0acf9ef67d3b6e06925feefa3afb65b"
    sha256 cellar: :any_skip_relocation, sonoma:        "867363743d698c5eec81984c9adb3155ef877ad7363f0f6ffeca8ab7e08e3792"
    sha256 cellar: :any_skip_relocation, ventura:       "867363743d698c5eec81984c9adb3155ef877ad7363f0f6ffeca8ab7e08e3792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8def1d2f10966cfeb15aed97e3e09ee1b2ff550dcaa4ebf2a8de5e54b3fe06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

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
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
