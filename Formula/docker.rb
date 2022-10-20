class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.20",
      revision: "9fdeb9c3de2f2d9f5799be373f27b2f9df44609d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "933e81d367250e74f62fc460f6321b8215aeadb76f19bd0cdaf6bfcbe7c6f144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "516d4f94b2851c895d384ebc2b1b1015ddc272e441a00f75a18963772d2fbb53"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c2e5463b0e80a8d492a8c0ff30714fcc41d8fd32b885344ff519961ded6b69"
    sha256 cellar: :any_skip_relocation, big_sur:        "23d1e4b07084b131c6c5ed0aa4f2ad52cc911037e7cb27e04eea4e3b6a84aaaf"
    sha256 cellar: :any_skip_relocation, catalina:       "db1d4c15acbf7a1c2571bd164098e0e932fcde8f719f00924b9d89828f322625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cc6f65d9b26544dd35bc6bfab477dfcdb95b90e7bde25314c21964214da4df0"
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
