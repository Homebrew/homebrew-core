class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      tag:      "v19.03.14",
      revision: "5eb3275d4006e4093807c35b4f7776ecd73b13a7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "598faffd6ba103a28d421c7a004c53d3422901bf475d71b1adb2e6c144766cbc" => :big_sur
    sha256 "d71d12ae8813da24871221cdabba7d01a0a2f8af298e4eef5406a29a2af67482" => :catalina
    sha256 "f282bf99e388228269a531561efea176ca9abb46fc25ae6a4da739839a6850cb" => :mojave
    sha256 "ec61a354367c1226467664ee770e6665c5f0a8be041242e226233566b58ccad0" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
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
