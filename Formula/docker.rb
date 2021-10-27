class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.10",
      revision: "b485636f4b90ed5a91a1f403e65ffced469c641a"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7fa41aea6c5d1b0f0f38bcc3bcc6b4107cba0b4e5a0b091200905232ed4c3a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39595e1525b94f6014e4f691a909ce3ef3a038970624ed1acec9ce81d95d8b59"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ce1c4a66a9856862d791aaf27512b81c6b312c44ef434f56edcfc842ccd8a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a35f8e87a2e6c4ad4d6ed8d423b825274ca85fd048613a6bc3277bdfcd158aa"
    sha256 cellar: :any_skip_relocation, catalina:       "ac90e89757152b6a0ec0fe1d6d69cfde14be882a1d9758a78de0cec1e9576c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6192c27351b82e5acf0652d88c30bea8e48d93046082b2743e6be98393f443c8"
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
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""].join(" ")
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
