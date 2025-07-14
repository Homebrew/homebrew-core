class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.3.2",
      revision: "578ccf607d24abc5270e9a4cbd5ba9b5355b042f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111ff58820c9ffbf5de576bcea45941b6b3bf5a8096108a2b6a71b1ec8d4470d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4729a98f42a24e8b28cab3390a5ed75aafb0fb6d91f03a919d969d4935993b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f72ff954f94cb3de9014a04d0d8888257ba6f5e001a6c1ccacbc951d0078e480"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3076ead074ebcbc62ed3d3551a3a0b82f0c26014bdc6ff88c2ec644b51c1981"
    sha256 cellar: :any_skip_relocation, ventura:       "406bc94948bc4a70f3ec716bed9f280985e4b178e99d64ad10eb789d98839b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b274223879e6f8e58b1990017c8407d0c21d352e403828f363c5fa8b5bee190"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
