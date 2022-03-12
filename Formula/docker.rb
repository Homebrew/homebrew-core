class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.13",
      revision: "a224086349269551becacce16e5842ceeb2a98d6"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f0f587866b5e53f620f9c7d478fd0679c4bfb10522b1bc2697c61868c2c6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee7d7e5ceec7ab41a96c0b36b7a0ed8cebdcc21211e996496bdb0928f0b26a56"
    sha256 cellar: :any_skip_relocation, monterey:       "487260ddefb4b4e7ec375ef846b2a525ad497a081814c7165a5a267945b8a3d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "835e484873eff2e02924c234864a188d9d49af6153fb3fff6984e57dca44e9bf"
    sha256 cellar: :any_skip_relocation, catalina:       "8cc0183cc50945ea1b6afc8a475cf3e9864f5fa2c80cfb64f29bd1f75403974b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5804b4b85fe7385d4c41447b2d92075c0d8fb77b97627074b6f785ccb98dd1d7"
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

    on_macos do
      assert_match "ERROR: Cannot connect to the Docker daemon", shell_output("#{bin}/docker info", 1)
    end

    on_linux do
      assert_match "ERROR: Got permission denied while trying to connect to the Docker daemon socket",
        shell_output("#{bin}/docker info", 1)
    end
  end
end
