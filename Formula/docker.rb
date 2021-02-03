class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.3",
      revision: "48d30b5b32e99c932b4ea3edca74353feddd83ff"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c273b146a2f75d0e8ea241936b237a9df4fa57d6630d2ef048a9e5a6bf17b90"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e87d3a378049183f43aec030c916107dbd5bb613d0e7f0a8b5edd9e4a39a333"
    sha256 cellar: :any_skip_relocation, catalina:      "174df73c2f40d9d059a4e37c427dcd6558f39b7691d9e7e08ddc03b9978bc7be"
    sha256 cellar: :any_skip_relocation, mojave:        "bcc4af650906a9a697212d380564a9e0e6c3d707927aa05a5c5d001abb7fb9f6"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      commit = Utils.git_short_head
      build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{build_time}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

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
