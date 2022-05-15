class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.16",
      revision: "aa7e414fdcb23a66e8fabbef0a560ef1769eace5"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cfb86b8bac67b5a9a4ca22de1f84d8cf1647c4e00ab068828593cf3cd23724b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8405bbd97e27a2a84dd8e7790d8c8471fe16836ed4578635fc4bb0e819f79e3"
    sha256 cellar: :any_skip_relocation, monterey:       "2258d1b64ddae96eb53e2919d5e7ac0e6e9f64190d9b515dfd8112a7f8d2e941"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c3c18ea3f99ad04bce2d1e3d3b446fad543d3cce78457d3cebce681ca2a031"
    sha256 cellar: :any_skip_relocation, catalina:       "b2ef1818c48476e19137ec43010d6849ea850bdb8d4bf68d14237eddff533d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de556f2818f5860ba0c142a26afde830480fa2f70a91cf9f1d8b8f41b34039a5"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = if OS.mac?
      "ERROR: Cannot connect to the Docker daemon"
    else
      "ERROR: Got permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
