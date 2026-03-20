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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a61c924104b1240b53cfcb88ec04ed228f460d0df17f3c258d8294b7a50bd0d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce00d76977f8c24e643f8c39f4427065225be9861802b465dbaf374c885df6bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e1b23e4e97cb523b5a6ee159e47234e1fcc50d42392ab041e86217c167def3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59f2171dfd46f5313ae2b348444b321cba92a4549c5e367fdf9eb5342e41b90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f3bd5f4112b0eb6b82350b72a32440bbbd52d220549753671eda1501fb1cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083413e120d3181155bd0d13f509b56383eed5d673664c713d38c67bdb0bd44a"
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
