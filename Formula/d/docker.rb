class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.5",
      revision: "0e6fee6c52f761dc79dc4bf712ea9fe4095c9bd2"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db660823d0f42cacc454a8e09059ea42be0b8ddf7295c5d660ae0ad3902ca9e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7990398b5535bbd052194944c7fc815d9944b087932ab10bd3fb77b3ec0dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd934dc6c8524fb8f6f1d5c8e556c30adf5ecfd975fc86e3a175c78cb32cf4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8adbfe5804719826df80bb03832411498e44c16e38167a7e36af542478193cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cfcb0ce773b3106a142db48c58f0bdd1df4203d4ade91c35a51f4c52d481837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d82652f1c365c0e06a22832234c82e8043ca447f2b538578f4d945407b38ef"
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
