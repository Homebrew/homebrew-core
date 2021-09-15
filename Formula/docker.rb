class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.8",
      revision: "3967b7d28e15a020e4ee344283128ead633b3e0c"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f006963b0e5393fa808670e88c3b6c6bab963aca3a7968f5bfeb41c331217c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e6f9213259e150fcc57d05c55336018031f484277577a07b5740c3bbbc1cebb"
    sha256 cellar: :any_skip_relocation, catalina:      "6f5af0ff463a59e5e11343f34a6a9f5d194cc8cde56cc9a3a5b70ecdf22e95fd"
    sha256 cellar: :any_skip_relocation, mojave:        "e71bd32fcfb1071531869362af409ca7f9903d8831a8551c694fbca6962397e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927529c05c83d23e433e4ac4dee94dce9b174101b80732a99726942e705ad35f"
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
