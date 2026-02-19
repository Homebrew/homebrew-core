class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.2.1",
      revision: "a5c7197d720daef7d8b9e6174ee78c0743cea166"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22f9479c4bf4ab09ce0e07107efeedcd0f141462496a0367e1052ba3d7eec81f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022cbc5204661a76c5bbdbe2c97d54f1ec65dbef7ddad328d3807978ca7c6ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89c4720fd7f7324b05de6ce7f7b7f64d369057abd7716e4ddec209a9e5dad5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5addad45cc92ca06a7a700808195549c53a53ce75f1d8c74dea94185ed80d415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c07a14258bc121c8b145f19a58d58fc94a0885b1506ce2dcce294222ad749a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c31d41cc1981fc06c01e49ed2e2e7fdbf6635344c2362ae14f5f45009e21ef6"
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
