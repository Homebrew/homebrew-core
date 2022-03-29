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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2208142e499908b16079d7910eaf5e0f18d7075efc44fc412266cf84765b56ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12112178ed50faba4f0223429ab2bb0648bdc657ea1d44909a65f9b23d26bb04"
    sha256 cellar: :any_skip_relocation, monterey:       "933dc4d32c59abe7ad65bd2a1f8b4d65567e6e6cfc6e4f4a55ab1397117600c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a7a5886a368dd08f527387d50cfcfc8d576f230b75d7c90159319580dd6ae35"
    sha256 cellar: :any_skip_relocation, catalina:       "47240e65d97f818f31063c75b8ea01b6ce5ab7d6ad2b0b45fc96fc95a1251996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67818b3680fe8dd8f4be0bf4dab0d0908c1160a7a81127549e22a6263a1a0489"
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
