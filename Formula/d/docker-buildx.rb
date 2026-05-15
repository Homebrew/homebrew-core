class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "864d734b660e57596f4e51acb8f2481202e227feae6dedf1dd6598e05e2584b4"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bf84a4fdc18a07ae7aa14e76e2616abefd562d6363658caa00ccd2eec67c4c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8544366a51c4e02f85af1d578063d2bbf677b92d41c4cd1f047505e5a552c279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be28a0f353bf32acb32973c916ef8ad26095b44f172fcb1b750082d0df68ff85"
    sha256 cellar: :any_skip_relocation, sonoma:        "f866e980da83249dab446882f15b102aa967be1632ab73d0982a65fa6a033118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a340dbdbc36e20ca665cc9c93c702b7f2913030b4f1dc868d32177a6f53bc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9a6b354e30441fd226be0c3f6a99adaa8b36e0b2dce5a19aadeb926b0496a1e"
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
