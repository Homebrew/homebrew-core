class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v19.03.0",
      :revision => "aeac9490dc54c1d48b3d7ae9a46f5a19b78dcd3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f516ac04672fb138ad0e6370a8ffb34a698aed0c9e5cc0ce4116c62f8f227efa" => :mojave
    sha256 "43c54870843134b76734eed0ace8bf6f4e3239cc2b2c2e04101613045cc2e1d2" => :high_sierra
    sha256 "d30af24bde794d68e21662e82e48f0989c8d6d529300d53e882f7b9d413c84c0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"github.com/docker/cli/cli.BuildTime=#{build_time}\"",
                 "-X github.com/docker/cli/cli.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli.Version=#{version}",
                 "-X \"github.com/docker/cli/cli.PlatformName=Docker Engine - Community\""]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
