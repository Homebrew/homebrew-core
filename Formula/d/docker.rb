class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.8.0",
      revision: "88096ef00576baf72a9cb45caa45c0544c40e0a7"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "998293c4bd31551c89a433e216ae890e4e93c9835b5ac6a822455655367bef89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db57a093b88166c74cb71830bcad96d7ec616d082b329814d9619ea1c9289e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a599492a022fa9e9d4674f81bff0d1becff94a77485f8da617ce9df97cb35bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d087926a9f15f9f1fdcdac3b5d23bb0eff5df1e9b85db27d823eec8bf8afc0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686024828902288b00eea79b6228b9c7c7c880c374a0b2f66d1185131a556d9c"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  conflicts_with cask: "docker-desktop"

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
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

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
