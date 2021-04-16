class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.6",
      revision: "370c28948e3c12dce3d1df60b6f184990618553f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "126059108fcbcc3a48839c2f4baa8f797b23d2ef812a4b90512027b6eb73d8e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "1928b0503d295e980a4820a9cf163ddd7539d04d9f45fe1f8036b8673dffe21a"
    sha256 cellar: :any_skip_relocation, catalina:      "749cebcf2d9bf351b02b9170a379cdb6d7b9573fdc223ddfab449e625ad9aa1d"
    sha256 cellar: :any_skip_relocation, mojave:        "e1d9fecfd09e0284e731816117aa195f73c93a98273bf309fe5fad073afc2698"
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
