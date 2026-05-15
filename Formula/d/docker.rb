class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.5.0",
      revision: "98f14649600f05480629d5c481878b1e1bcb7c17"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27347b98fb8c009b1de2bc983f60aabbaac463eb28fc117582f93aacf55c533b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40a7f9ea7e472067a103bb2960fc34f17963b06cd83f616694b6a4c41db056a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2255750cbf5116bd4824d55a0184ab8a041439338b74e6d06fc0b6e752ae77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ae977dc27885687237d97b8a60d8dcf7cd0e447b4f5796b2e565762cba37270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "726e7cb308174fa63e426fbb6830e2aa5714abc3f8574fb59489f9d7f0267dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "986d666377a832eb928074d16f64c10d9c69ca6b4ebfb997746f00b89746a38d"
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
