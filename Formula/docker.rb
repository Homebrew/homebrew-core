class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.14",
      revision: "a224086349269551becacce16e5842ceeb2a98d6"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbdf24dcbb9cc7afa917d6f1345ebd608226777c53136a336194161f4cdc5004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c82963e21bc4093adc0d4e416f52b4ba53f71abf4ff6a524a3d5e4762a7954ff"
    sha256 cellar: :any_skip_relocation, monterey:       "fabf58e97aba772fdd8abd28c2688b3511161eb9c4398f499bdb13f706d07ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dbc6646ca8429d7cdfb360e66fc3b3ed89719ae8b339133ef4f930b78d33c1b"
    sha256 cellar: :any_skip_relocation, catalina:       "7039c46193350f25ae383581fe4963bfd8925f3ec2d84fdf0156c73df44363c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0433b9609562a733ad01ff5d073f7a492040aaf3f9eae9ee0898802d9447019"
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
