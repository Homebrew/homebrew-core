class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a5103b5b1e4b8ca785445917d4ead07885cd0ae376fbe73fdb0061d26312eab0"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "417db1ab6fcaab6ddf8304313125b6006d815bf4f0431c733b57eb5fc1ccc438"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f72da9d56c73b1bbbe680481b3f38b6a0729ee3462c9cf370c088cc969040f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92d6aeae257edf5a22d6db05e201eb5f94065d1b54d6a51886cfaac8ef6ffc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "21890d0625b3e7d5c356e13b083d2e8497c079e3ac4587266430e5ce5381211c"
    sha256 cellar: :any_skip_relocation, ventura:        "a9efc20b954edc276e48730619ada75eac4fc6d5189f0e0ed688282a3584c19f"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8b641b97275571880709751ff949194f8e5010614b12feef893b7c7bd8842b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0250cef9bbcb694bcefa35d2ad98470bec3920324048fa56456986b3d33b1fbf"
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
