class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v17.12.0-ce",
      :revision => "486a48d2701493bb65385788a291e36febb44ec1"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8c927132050feefd249de923b86a4d2f9c2b110d480e7fba7f3b832176c948" => :high_sierra
    sha256 "9888fdec5b45a02297affb5d5b3adf165fc8253ec0426d0c23dda3da7f2552d7" => :sierra
    sha256 "84212dfd11d1062df59bcf72dbc966820e46601b7ebbb38ae42761e1f0689d5f" => :el_capitan
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
