class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.5.3",
      revision: "d1c06ef6b41d88d76866aea43c246cd7c63d04fa"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc5abed82384f4456e06b53bea84b71b0f6c0f5dbc249c44b727cb8e2b87510c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf055342f59dedcab58c65501162d8d6d57248f36e6b39523abdaf980e3b51f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb84908515f0c9cf22b062d6ba058584898a3626b29ec106c7c99bb22753e036"
    sha256 cellar: :any_skip_relocation, sonoma:        "1375de0e42d03ff5823e7ab1bb04ac58a375a0cb497ef22613badf02c6155a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1908d73d5f175064aa656cbd6c64fb1a6468a9aaf28d408aba607aea743d298b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d327d9e856c3b636da0a034c6a497cc9d5796eea29daa51388b809ea96d5d598"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

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
