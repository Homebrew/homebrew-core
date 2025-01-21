class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.5.0",
      revision: "a187fa5d2d0d5f12db920734e425afc758e98ead"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1158b2306a6469819a08ccd97890063113243c49b90185eb0b63a94cb0259f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d1158b2306a6469819a08ccd97890063113243c49b90185eb0b63a94cb0259f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d1158b2306a6469819a08ccd97890063113243c49b90185eb0b63a94cb0259f"
    sha256 cellar: :any_skip_relocation, sonoma:        "704d78b3a6fc5b02de5750cce6b5fe52ffe16d9dc9a8bb7e513df9470b34ac15"
    sha256 cellar: :any_skip_relocation, ventura:       "704d78b3a6fc5b02de5750cce6b5fe52ffe16d9dc9a8bb7e513df9470b34ac15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee510ea4520ad877fb902f807572184afe0feea5ee06a16dba85e288c2fb4c34"
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
