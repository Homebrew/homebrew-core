class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.4.1",
      revision: "055a478ea9010a19d0d4674c0d0e87ade37a4223"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "092de39a0ae10b955048ca40a1633ffd21eff639e453ebabc6f3c6585f5c9320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07852f1cd2580189a945598bd6dfdac4be16cb870482115c6936644f0db629b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4111e1a04e2b3e4b3c09bc79162271e902b7ae095baa69f425f4d20569ef5f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f896ce98bb2289b9425a21883c6361a693f299f3628a8f452b58508eac3f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d363db8bbd3e0aec9f42b404fa9bcebc2b5df5846d99d7386a573fca35ff9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54766feafbc89c66bc170d0c3389aa0312c075c6d29f1be0e49458e4ed1f082"
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
