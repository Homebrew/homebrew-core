class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v25.0.5",
      revision: "5dc9bcc5b78ed23f12cdd68e4285ea1c216ce2a1"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2868bfb2db0c75cc48b1cd2d52fe7fbf878a64086a03df98e1f59e0939fb372"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64d4c7533c543dd33637d7ac16294b59f2c8c50b766a7e8fa278f9597ff21bdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "224635b9da0ef0c7a1ece289ac6c7d96f9f703c13902e87eb59e85232d556a81"
    sha256 cellar: :any_skip_relocation, sonoma:         "f62dc6363ab11b6d2b3aa8a0c7ad9add94968164213cb0457e38a4be581e1b7f"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd8e5a2af273f4bc9756a9cd5e7c66e16d26c5e34534d69f45419214a359784"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5def81e5b7593feda37ac7b82f9b9d4948ec0bd9e99bd334e5015e72c62b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f1657f238d9635ad184f854ae582e6eb25427940f147c4ecda16303ec30988"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

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
