class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "6e77b77d9b7fae6f00955968569ec32673ae6e2bed31587ea016f9a5169b0f61"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e38841c5d50802af52826370e489181bbdcd755a530e707c506810e244afe073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f5e7f7a2bb5ee533ec437d957cd1820e177cfe776fdc99b7606c9258100ffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479648f949b1c960ee95a89957e5987308d02bcd0fe7ca224b2e3ea8540e5aa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "024c4f509249bdfe048195c49194a7b164977fc06e054d6577afba5b4b7c2c97"
    sha256 cellar: :any_skip_relocation, ventura:        "d7acf5d4b47519f8e02b8dcaaa3c77971cda86f67b2a28debf6a0cca3997a30f"
    sha256 cellar: :any_skip_relocation, monterey:       "853a9e9f65d53c52d5c80c6e64dbf26af23d134ff5c15b426da18815a7c4e21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290600caf328b772e887fe6ee99d7612f96268e4c3633ddea6d7e6e63ac4c054"
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
