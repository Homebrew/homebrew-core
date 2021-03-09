class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.5",
      revision: "55c4c88966a912ddb365e2d73a4969e700fc458f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "850164428281e1382f71c129b7de8e0295557c8dd085513807602e402a88b347"
    sha256 cellar: :any_skip_relocation, big_sur:       "6945466371797914754b3f42f597c119703fffa5d1dd0c72ee5c25048f1ac968"
    sha256 cellar: :any_skip_relocation, catalina:      "aa8c1e0fb619cba19be6a633b0984d559dd4c091f234549df7f3751d53a11355"
    sha256 cellar: :any_skip_relocation, mojave:        "d209b6efc28e3a496a689f7a9175b766da8cf30af40518a805ea89a19d660330"
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
      build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
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
