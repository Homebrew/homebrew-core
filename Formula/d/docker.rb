class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.1.4",
      revision: "0e6fee6c52f761dc79dc4bf712ea9fe4095c9bd2"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "669602bfea8c74d43fa0454f1eaba518a689dd12a95ab3f0a9b8677ec709e507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e098a2b9638a95e2d76383fd2a86d77bef93635f2301eb432023dacb6ae6db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb4bea59f3182b3a9e306bce3be12c1a5be854bb19d9a5a8ce80373dfcb80ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "50510c50e1d6a8ee7a34ffcca6edd098a48f529935e83604fba1dc3ec208002a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51e038900fbb5af297051157231a264b8dcc2d7f703b437d7fbcf470448aa73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4ea4d48314ca595831d5759c8f0f6a6b549cfb56141cf64978dfb89ffc1e6bc"
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
