class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "2f2069554305c9659dd4a2b4eb10c7aeab97e52e89cfeeda07f0c0c43d19ee80"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beb6d19f7d093351e6596cc6e846eab2c0db5b199e3a000ff889c5d8e7cae700"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d21eb4f6401d61ef2f6fcaf8fd9863eaf0f930a350c92fa9b6a19e7da41db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86602151079bbc84f0ec43b29fbaae024004b6495a14555fbfe46f7bddeaa970"
    sha256 cellar: :any_skip_relocation, sonoma:        "d118b27197ba728821cecd3eb94289a04e45e0788d257abc3e4763eb002cfdc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac10dcf0e9b7b57b1452dc37eb1785058a3fb2443860ee2398cd15d047eddc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72de067f376a353fa5d6762c807a2f2165564ef0a60063c18f36fd5e6b5c4d8f"
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
