class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.4",
      revision: "f480fb1e374b16c8a1419e84f465f2562456145e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13bc7d754ded5d83ac1c9eb6f6a05d5076e333b1c20f72715b731f404d398141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bc7d754ded5d83ac1c9eb6f6a05d5076e333b1c20f72715b731f404d398141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13bc7d754ded5d83ac1c9eb6f6a05d5076e333b1c20f72715b731f404d398141"
    sha256 cellar: :any_skip_relocation, ventura:        "94d3b0b75577494087ff4717add72b25d95253edde881ad2be1cd4d8df4ab1f3"
    sha256 cellar: :any_skip_relocation, monterey:       "94d3b0b75577494087ff4717add72b25d95253edde881ad2be1cd4d8df4ab1f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "94d3b0b75577494087ff4717add72b25d95253edde881ad2be1cd4d8df4ab1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35a9571d5f9c189f80786b3409e2945323355912d6e40cbc8951be0dfb559202"
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
