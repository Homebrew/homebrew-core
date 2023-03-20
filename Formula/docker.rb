class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.1",
      revision: "a5ee5b1dfc9b8f08ed9e020bb54fc18550173ef6"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef81081b438f56657c3ccc20c6ca52eaa0766cce3766f7c64b38198d647bb894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d8857103e5a27a0538f2b5a69c77e2e054f00f029c22c5bf5cd9c69ed67b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b4fbf235000c98f1da598933b2e952605a87c22a54c8ac8cd16321abfe2ec4d"
    sha256 cellar: :any_skip_relocation, ventura:        "be4da268a3d80e06dbd6c96ec7e3d8098f737a8aced36d9ad2ec792e4379b8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b299bdae239cda1ecfc90793f17c0fd85a89cb85f9a3762fafabd4a1e5bcbcf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e37d310b0a741fa90364e3770458bc69e4f6265ff7eeaba6fdf80b49bed5141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd1e4fe3952dce4c2b83db56966f55ef9643a5aaacd7d7fba06686c64533c11"
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
