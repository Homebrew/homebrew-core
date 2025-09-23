class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.4.0",
      revision: "d8eb465f86cfceeb57f8582e373d41a558d35503"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59f5e73408c4fc4e9216ce4135aaf45b2333085e14c0fb2e269b18a18b4ea05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16b84e8051d0e5776b5cb9eabfac72b34e7e9c0b9fcb06f7f08594d2b9f26be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4aa62e9398789ed259d59e34684b848084f4b43f0ccacbbcb1795f996d51599"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22832800661f1da1954b5e4025ab897f48ae84bfc4f5988b87313c1e50c6bbe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0edc16df66d8603b216c2093e30ba73a27387bf6c6a8833387680a974a5987f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a32fe1348ee00282d3900f86e8f1272bfdfdd543813408d78c62c32d1b6adc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c055662664c02f22f34ce79ae79590e20b869e619aa043a75deeb93b2c3a1c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f68c19ae934558c8139a0028142717ffe5d1f00a660aa087ad029c1efb8a478"
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
