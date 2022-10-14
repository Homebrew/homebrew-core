class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.19",
      revision: "d85ef845332936556fa43722fc2feb25ef94f39b"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f853f3f8c8a5d43c65c4199c4bfab7be300705e540db86fce608d483d5d4ff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a2227d9979b59b40bd39a52049cf331adc8c3f57835d7dd88a092a0ea2dbc45"
    sha256 cellar: :any_skip_relocation, monterey:       "7571dcf5f4108fe20c7c911d09a12e1cba933c40b3e49313d32047e65bd19775"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f842587c7f75f8ad95c121a04b2371bb4f718d438ee4d65473579e35427bb0d"
    sha256 cellar: :any_skip_relocation, catalina:       "ec533df77d2238eb0f9ccf3246db8e50af57a8e984e01a3ab8020c320d74b4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7067fe63beb062cead9631e572a7d6003a6ea516d2297e33da8c63fdeacd29b4"
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
