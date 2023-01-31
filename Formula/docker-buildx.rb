class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.10.2",
      revision: "00ed17df6d20f3ca4553d45789264cdb78506e5f"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2187a63faffc9a93d460c61949bba2bc9f91ee0dcbcad2eccc27733ac52505ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30e5caf3f217536d71e5e62f37df9a967a2ce1c4f9f5eda8c5ee982eaeec9bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9edf22cebaceec9dadde91beb20b71b0d36f26f480dc487ea16316a91faccab"
    sha256 cellar: :any_skip_relocation, ventura:        "4b3333e42c7026686dd30b5ab8968a0ea7fb054cc4c13a59389e299fc781a8a4"
    sha256 cellar: :any_skip_relocation, monterey:       "12ce36f59f6f0623de2bde939e8a19f7998e55e405755c7968405ace237688c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5a45981c4515c6636edf083446009735e74e52527ceb913960e3707bb5636b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe16ee536fbd8c93ddac007ddc49c692aeeeb91fd10c5a1d6befed0ad59cdee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
