class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.20",
      revision: "9fdeb9c3de2f2d9f5799be373f27b2f9df44609d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b857ca7dc58011d01d67020c26ef4647db37bc243e34cbe75e5eb7b37720a468"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73e07afab00c5a6f9ab1b1e86e2a22266bd4faae057d70c32ec0c07ef84bfafe"
    sha256 cellar: :any_skip_relocation, monterey:       "91841200e02b0f0b1487a1939e06ebdcd3e5a94ba31e4b26829548b78b1ae58e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ec89c6070ecbb52edb70491abbd41592400dd46fe66c4545fa388c0124605f5"
    sha256 cellar: :any_skip_relocation, catalina:       "801784cbb3e67a38c9365e66a2b02ce8322a1388a93fd84989ca43ae8cc8d831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e8a63fd209735ceae00cea38ec015bfa4f34ede4070137d2183fbe51d8e7b8"
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
