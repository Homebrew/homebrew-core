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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30cbb4913d6a7550a85aad8ad0089c97668949d092953fa2fe224d2f7b547722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bcc119ce6e7f1c7aff8d666ee2854ed16a17ebfc4c15a4e9157538ffa72f668"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8746daa90f294fce2ff21fb422b109602f49e1b3ae0e3f89822ce07d43141aac"
    sha256 cellar: :any_skip_relocation, ventura:        "caec5764881ea0a52578f5a027a519add9dc11cbd0b8e2710e835e5fee704a95"
    sha256 cellar: :any_skip_relocation, monterey:       "917b51a3237dc806f408787ee9af6ef2b4170068b672252d0504389beda8541b"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ed7249bf6e8902eb63784a23d6360faf5a037519ff0eca48eee14dba6908f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c1394b67ca8c4573f2688c15367c0365fe92cfce937e66ac34551fed475f86"
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
