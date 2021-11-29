class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.11",
      revision: "dea9396e184290f638ea873c76db7c80efd5a1d2"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39636e61c3e8f2ba6deaed04e65abffd1e2eafcadd14ec9fe2cfc128a2a2fa6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fb830e4188ee209a71735353ab2f827d5a9c4cda3db51304b6a5f9e9ee6802d"
    sha256 cellar: :any_skip_relocation, monterey:       "bca5c76c28435fb464d35625192f128e24d3813c9e1058ffd8023d56603b0e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b429ba513374b0799d676cf1c2c4148bc76438f8a0a2c381d5da40e0dc0d99e"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd59eee1a8a16ed966ad68e4ca4dd29c446953a08baf0026b908842588a17e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a522069c957fb3fa43e18a47c9a388ae3a112ecebb0f840029750ab5ff23f139"
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
    assert_match "ERROR: Cannot connect to the Docker daemon", shell_output("#{bin}/docker info", 1)
  end
end
