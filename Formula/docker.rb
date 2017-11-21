class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v17.11.0-ce",
      :revision => "1caf76ce6baa889133ece59fab3c36aaf143d4ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "81e5aa8823fd683544ddf10e4cc12b82110421744e7f316902994ce06cb4e13c" => :high_sierra
    sha256 "da0693aabdea75aed708334e8a2e05eea55b98de22db61d1c91adc50b286b468" => :sierra
    sha256 "cbed1555327e435795d896b90824919f11079b9c6cf9a2510f20ac3cc7ed5b3b" => :el_capitan
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
