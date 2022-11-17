class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.21",
      revision: "baeda1f82a10204ec5708d5fbba130ad76cfee49"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f935599f6d43f4216c9a233eee6ca1898355c46ae428a5303c6417a6fb10eed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f5089f113806e23b3f127ef50fbf2ea24e6bf13f512c34c5e1d1f1e756d03f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20f1415827772111f88619939ce53e0adec09b8e1234cb73e9d6d64f767da6c2"
    sha256 cellar: :any_skip_relocation, ventura:        "98f22d3d055114e2af3e6e68c6891635a4220c40a5093e3d2f9f60bba26b90cb"
    sha256 cellar: :any_skip_relocation, monterey:       "1564c197bb14711f8e79a44d42e50a61d8f0129b612cfb127e7cce4428dced19"
    sha256 cellar: :any_skip_relocation, big_sur:        "23502a2f74f762a97814fa961d1634544ab6fc7bba766526b21e9404eae384e0"
    sha256 cellar: :any_skip_relocation, catalina:       "4995f40ed2e34e381da74fd333b76d91ceb7a0d47cd6deebc56cee5f2b7425b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8faecde8f3b1d82f905f846e07d9125bed51682701200b2cb87e44c7e23ceb99"
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
