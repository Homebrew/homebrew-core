class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v18.09.8",
      :revision => "0dd43dd87fd530113bf44c9bba9ad8b20ce4637f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e52f639602d7a5def86a599f62f8a514e6a519c07623a473b534a0cb236cee47" => :mojave
    sha256 "0c68910a0d08ecdd8b4b5695e51006033725ea5801cdabfb5c3c163b59116ab2" => :high_sierra
    sha256 "bc29ea4e4f0dcae4645520084dfd9ce1d3d69a778cfae21c6d7db556ff4d5667" => :sierra
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
