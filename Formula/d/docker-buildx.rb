class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "2b922ec33a85a41e47a0ed0d6be086d32fc33c98adfa59dac714821375f304be"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bed1174137c032c636c18145541930235f5a6471286efcf6de83506105607925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "003852a183d61046cd4ebb279de9060671fd3c019079f2e5bbae6ce902e02222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52b8215a3a895698e7c44cc0d4f122f694af4dc1974fe26457c46dd9572eaf25"
    sha256 cellar: :any_skip_relocation, sonoma:         "98d7d89543a1663a8afb3db055fc18236a9145bc0ffaa313a89fbd243b808d68"
    sha256 cellar: :any_skip_relocation, ventura:        "dfad24fd06ff7719277d3689ec22213b1323bc3053325008834bf25782c91ff8"
    sha256 cellar: :any_skip_relocation, monterey:       "9b75c7cffad90762b0bfa8637c29519635a0526ded225651a68493673ed6dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc66851389ecfde09144fa2808818e8ec00a241bf6327d7ed77da63632ad75c5"
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
