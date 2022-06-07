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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d72980cf778e7692c089e0fa5cb0574aaced632904691d86b31dcb925e73a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee26d69f2b0809598012ecf8be99e47d0580561ae44ebaa62a27193b20b85958"
    sha256 cellar: :any_skip_relocation, monterey:       "0f74d14c67d9a698638e63dfee9c8fd60fc8ea091f6652f8cc06a1b7f921ce59"
    sha256 cellar: :any_skip_relocation, big_sur:        "fafe17064fb6d51f509c56954bb7c8c29963f750df06f81c572e520041cf00bc"
    sha256 cellar: :any_skip_relocation, catalina:       "1c24ca42331c71645a531fcf7e94d2f129110cefcd23a240ee1d3b51b751a0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700eb5ad46d661acd3f7539523451df9123728d1d3312f268e378d1827d847ea"
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
