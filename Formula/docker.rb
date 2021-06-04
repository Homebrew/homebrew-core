class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.7",
      revision: "f0df35096d5f5e6b559b42c7fde6c65a2909f7c5"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c4ada3bfb0b5e0915079f5a26ea28e46b506e6bc1ad859e609272de7296416c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "626a28393a8e833b5848a52c1fbe2b71d63e1540c4c689216c3d2b27d2a871b4"
    sha256 cellar: :any_skip_relocation, catalina:      "4d09b76ce85c651cb4454ddf2ed8b3f680231793747f5d997a1a41111e92e997"
    sha256 cellar: :any_skip_relocation, mojave:        "7f947fa8659c8b81daf5fdf3fe065d97d7443db9653fdfbcb5e91de724635d22"
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
