class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.9",
      revision: "c2ea9bc90bacf19bdbe37fd13eec8772432aca99"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06a4f27c2c0a84b0321ba20e6c6f8d37de44eddc66bddda737d6a725a9b8c07e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0cf1c8352a7172bdbbc28d7c16f4b5f91f65dad382abe76b99a7622b0fd3659"
    sha256 cellar: :any_skip_relocation, catalina:      "34d879c9c88c4df9c676d2cc6e1d5fa348f5530f1420cb5d35b15ea49fe7f87d"
    sha256 cellar: :any_skip_relocation, mojave:        "5098c15dcc506cbbcc2916556ee2e034b0e5143139c7541da751aa194076e9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687d2a22221cd497810d4564a2abfb01e9de12019808e9a9f75a65d81d10b4f6"
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
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""].join(" ")
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
    assert_match "ERROR: Cannot connect to the Docker daemon", shell_output("#{bin}/docker info", 1)
  end
end
