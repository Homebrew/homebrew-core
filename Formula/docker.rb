class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v18.09.8",
      :revision => "0dd43dd87fd530113bf44c9bba9ad8b20ce4637f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c12184ace3e8a3cfafe1c451650830835caf7130be3dfba69f36df54a87542ae" => :mojave
    sha256 "62cdbd54b762055ca2ba73d29814a88674acfee09251c01c4285f118a6da5baa" => :high_sierra
    sha256 "1a84a3292568211443470dad6435ce77d1bb03fea23090d684c5d39db4385421" => :sierra
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
