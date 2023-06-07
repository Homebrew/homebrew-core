class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.2",
      revision: "cb74dfcd853482dd43cb553106b1e0cd237acb3e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af41aa7f6dbdc06e6da2a2ea4c51ab4432a87214944e5f10436066684208eba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af41aa7f6dbdc06e6da2a2ea4c51ab4432a87214944e5f10436066684208eba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af41aa7f6dbdc06e6da2a2ea4c51ab4432a87214944e5f10436066684208eba0"
    sha256 cellar: :any_skip_relocation, ventura:        "8c94c95aaba3da26954bb04ef3c2f74c80a225b8a0646f19c3d77b5d3d69321e"
    sha256 cellar: :any_skip_relocation, monterey:       "8c94c95aaba3da26954bb04ef3c2f74c80a225b8a0646f19c3d77b5d3d69321e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c94c95aaba3da26954bb04ef3c2f74c80a225b8a0646f19c3d77b5d3d69321e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a939fd758546b8c0826da45c3ea01d1b026f6d36e15abfb251ad02c3ebc7d49e"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with "docker-completion", because: "docker already includes these completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
