class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v19.03.0",
      :revision => "aeac9490dc54c1d48b3d7ae9a46f5a19b78dcd3a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca2998e7d6284cdb9bea2ca52b2b2daa4f05ea16b9d3f0d828ef7f60a8c3c4c" => :mojave
    sha256 "862d3d4c07545802527f045a55cc3179e29d72c2d77f2a6922403c0b5e04f8d9" => :high_sierra
    sha256 "c3616a9f80e42c53a25261e605d681202c47a9d8842d3292cc93cf5f57c4bfcd" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{build_time}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

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
