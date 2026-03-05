class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.3.0",
      revision: "5927d80c76b3ce5cf782be818922966e8a0d87a3"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1963de2ef73d3d1ba3805f222538030ef179a820e89582e69767da68cd8a5857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee4d656fe3c1c499a3a39cc2e1b88b650af31082bad1ae25572a5be475be4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ad89275e39b7777662754a971ee64593d8bd6cfa41c3af1bc70abad0444f53"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a03c201bd092892f62c68908126f5cff6f16b191eec5cb55f9c4002d7bd6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec0c8b58470dc0867d1ec8c82b5c4826184fca43d943f6a84a6461ea4cb6d3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c428bc08700a2b54d031b9483975a24bc0babde7661c31c447b03ed6f3015647"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
