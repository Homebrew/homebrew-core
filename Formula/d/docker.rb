class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.5.0",
      revision: "887030fbe83f5368566ec3b35e15a4ba13267a62"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab259f3dbb54c553ff16cce9bb47d8bd46873e6fe5cf38d04cec2db4b1a8c26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9733eab92fe9c5036128062b08462d3e04f54f7591351b6f594548761ee8fac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60afa2ad6c012ae527d41d29c569506682ce1c62601dfa5e6d7df2af1093b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "56981e8bfda779a75db6a90cd232733ffbce017ddb8cc3df673783bd13245a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ba48fb3669dcdf28d6099bb56cb8eb3ed70597e55db84f5419fa3d1fb49f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3063cde6b2a55a6cc03057cda0f02e9f9169b84c4419a8896a799c36a352dd"
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
