class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag => "v17.12.0-ce",
      :revision => "486a48d2701493bb65385788a291e36febb44ec1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9664715c347648c3a43533799e9666c07c4d6739bb2aa7e31b86463732fdb89c" => :high_sierra
    sha256 "9d056ad9cbb15d2f27ad68a0b66982b702575a3d8638a3673232a51cfc438e3c" => :sierra
    sha256 "d2363024de9f46c941c1d929b03aaf8243ad1de2f5d52df6db90ae7211213761" => :el_capitan
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
