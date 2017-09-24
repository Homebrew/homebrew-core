class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v17.07.0-ce",
      :revision => "87847530f7176a48348d196f7c23bbd058052af1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9059211aff9fac56d70b2b3159db5b5857fa2d9524e84fa7a88029642d353fe4" => :high_sierra
    sha256 "11b32ee5016223a9f4f2d1268bf0aa4b0bd23836ed3dc2cb4284b5771cc96080" => :sierra
    sha256 "d671ad1994cbb5452459b7fd6aae3d9365cce5593974c09f48c6de44330ee6b7" => :el_capitan
    sha256 "115c22e0f10c80376f04514295fdd3ef41c95c10bb7c658b2670fb921b556501" => :yosemite
  end

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool" => :run
    depends_on "yubico-piv-tool" => :recommended
  end

  def install
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = ["-X github.com/docker/cli/cli.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli.Version=#{version}-ce"]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      if build.with? "completions"
        bash_completion.install "contrib/completion/bash/docker"
        fish_completion.install "contrib/completion/fish/docker.fish"
        zsh_completion.install "contrib/completion/zsh/_docker"
      end
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
