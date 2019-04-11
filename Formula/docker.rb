class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v18.09.5",
      :revision => "e8ff056dbcfadaeca12a5f508b0cec281126c01d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ddd6a5d7a186fdba4ab5af2be313d57d796cef2d6b8ebd1396d8a86b49086af" => :mojave
    sha256 "48cb06562764012acfe5336036e5d2ded9ac56e3682df16580658ca4917bf502" => :high_sierra
    sha256 "fcf79e61ee5a9998bfd6e1927ef8e86b96f639349e309bb91d0aa2cdc1920edf" => :sierra
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
