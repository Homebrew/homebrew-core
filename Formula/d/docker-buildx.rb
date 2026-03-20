class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "fc4b82f21f766a704fb26239550d37dfed3936b6e76580cddb00407f13f48f6d"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad3fd7283b4f47ad805b80a547122c0f625397fe46e3d5ee1cfdb4cdea0fd6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0904d5b482259fe2d9052791adecd2dfc2226095e3df9c3622399e266e863e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02a90b329efdf71efbb590902625d4babebe4140bb2b1aa16945e10d183f600"
    sha256 cellar: :any_skip_relocation, sonoma:        "895f9694b2fe6b569e9abcd00572edd7aa8af9113a636833106a3b295cc4fcb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c38cec0b8c93dc3d22abddda84ed55f17f020749e5a93d13ef1ac5ea033de944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2483ee1c17dceed78b395a64c9f3f292479f34ce9af079faaa09d490bbbe0dac"
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

    generate_completions_from_executable(bin/"docker-buildx", shell_parameter_format: :cobra)
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
    assert_match(/(denied while trying|failed) to connect to the docker API/, output)
  end
end
