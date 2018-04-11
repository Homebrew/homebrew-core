class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v18.04.0-ce",
      :revision => "3d479c0af67cb9ea43a9cfc1bf2ef097e06a3470"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbadfb1426927ab3643a03aaa36c9d2f9557532d1242c66a49196d56b4347110" => :high_sierra
    sha256 "3a891a58beaf58cfd426c8b28de28d40641f7c99d24f3122d423be238a6da4ac" => :sierra
    sha256 "1f854142829a3d1f60871e50d49145e0b90b80832bc64cb000e2f2f5a488988d" => :el_capitan
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
