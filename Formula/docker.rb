class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.17",
      revision: "100c70180fde3601def79a59cc3e996aa553c9b9"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2549cc84e09e7faafb11025bd732cdba63149a97432cb5da6fd4bb2f365dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2369b3c69866e93196b343cf623c5c1ea66338b91f6348386a345d4ef432aa49"
    sha256 cellar: :any_skip_relocation, monterey:       "a74f1ea366019a6b92f4130d487ba6e180cdecc8d28c294c796f8c11b5869df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "89e2bbca9ea87ab0f66b40101c4bf1f0e055aed2867ee73fa2a65974cfc7b069"
    sha256 cellar: :any_skip_relocation, catalina:       "b5c8e6b1c69441e0a225f3ab1f92b1c4ddc3f0612b364d052f9019fb84839c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7124e15cd9f187e561bef9fe42edcf21f149f37fc77524f177b4b3c40037aea"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = if OS.mac?
      "ERROR: Cannot connect to the Docker daemon"
    else
      "ERROR: Got permission denied while trying to connect to the Docker daemon socket"
    end
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
