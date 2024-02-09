class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "9cc176ed55e7c423c23de35bd31df3b449261f1b90765c17f003bd4de86a6aa4"
  license "Apache-2.0"
  revision 1
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6abbcb1fdf69b1bda1b4d4bddfb3c5774ca5214f5834b112285b6c91d925e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ff063ad2ded0882713a52fb5ada72026874140c53ece771744fa9f120fdad7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce19013244887dfe3ebb202adb007e9c02c146fe83a8fdec42a4015d140166db"
    sha256 cellar: :any_skip_relocation, sonoma:         "be7748b244d1a6a6c624cc5628703c81a1a722f67e80e90e2b051ed7c6b2fff0"
    sha256 cellar: :any_skip_relocation, ventura:        "445a345e2e5657c0abf87a8da5247f7b2e3215e5a760e32507bb13edac7922db"
    sha256 cellar: :any_skip_relocation, monterey:       "c3dcd72e2609dcf56bb057dcf9583bae82dec934303a7aa48cce55adeb0dcdc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1798be0b31d54c97c5ede749f626a218989fe7e032155b84971a381e8f57c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

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
