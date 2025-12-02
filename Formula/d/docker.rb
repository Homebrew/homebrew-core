class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.1",
      revision: "0aedba58c2eb75e45b5dd56cbad16a6876a38af3"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46dc81966bbc2dc032bed6f4fff94e6c3d641b339098a6ba0f60c113da7664d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e692c0a4a693cd9e9da9fa250e5a3f1554bae5ab6e91a2069f3ef48e98acd0b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b11aa857d8455633ac7f0c82d85919f23bc228ca4a164544a2ecc5ea522ea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de3676e17a7b1579c9a65b43a65e622eb21708fee5c5cb19a3b712709be52ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f0dc4c789093ee16cc54980f256d93d62f81229f05484c369a7e46cbd15015b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa4c1dfce15c8df7dfb9439c0c34ba779e5130510b10d8694f411df4729f717"
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
