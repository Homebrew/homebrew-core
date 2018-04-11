class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v18.04.0-ce",
      :revision => "3d479c0af67cb9ea43a9cfc1bf2ef097e06a3470"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f8003a13c798733cff67a1916b4b65ca39bad352c6da2bc0d254fe1901b7f13" => :high_sierra
    sha256 "c96f294123ba2f24d4d1bd10ee3b62d769bcbef63563596e3e1e6a1536529314" => :sierra
    sha256 "3bd73cccba25130c79315c6aa6565711bde65aa841cbab72eb6c2f605e907f1f" => :el_capitan
  end

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool"
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
