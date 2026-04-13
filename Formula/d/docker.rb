class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.4.0",
      revision: "9d7ad9ff180b43ae5577d048a7bac1159ce7bacf"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178fd5bfe589f1d5026018ea4bcf0fc81811b28e91c1d85c3f8a7abe45be11a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3607767da358c760b1783f476fcb63ffe11c68362419197094eedc23237195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5ce6774a64a8a645c7b9f26ab9f8f67dce5185608aba7e6bebecd44127d242"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed923243d0df3fabf2e999d801a3cb3557cdde9cd44eed1cbe31e6fe4eb609d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026ca18c9e475f51ffd6d4977c4b056b079135be5ee11b7f2fad19823f0f4c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ac3aeecb6e3e6c11e778590d6934e38d3bd5580226a44c9524ff3b648b2f52"
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
