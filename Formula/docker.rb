class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.6",
      revision: "ef23cbc4315ae76c744e02d687c09548ede461bd"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e8b713680d4d805022ff9f563fc8b434a303f64cefc16cbe9c149e4674c120e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8b713680d4d805022ff9f563fc8b434a303f64cefc16cbe9c149e4674c120e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e8b713680d4d805022ff9f563fc8b434a303f64cefc16cbe9c149e4674c120e"
    sha256 cellar: :any_skip_relocation, ventura:        "f1fb7597081e30543f2fb8293d86054cb3d995081377a750f6075ab9a30a0be6"
    sha256 cellar: :any_skip_relocation, monterey:       "f1fb7597081e30543f2fb8293d86054cb3d995081377a750f6075ab9a30a0be6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1fb7597081e30543f2fb8293d86054cb3d995081377a750f6075ab9a30a0be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94266ff39b24fd62fed5c8b5295378bd922cbcc196aa49f6ceac8a50f7e3f237"
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

    expected = "Client:\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
