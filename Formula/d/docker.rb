class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.1.1",
      revision: "4eba3773274f9d21ba90ae5bc719c3f1e4bb07a1"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4cafb97ca3f594ca7050af4399ec3ad80584c6ea703459b76a9a4ed254e2e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4cafb97ca3f594ca7050af4399ec3ad80584c6ea703459b76a9a4ed254e2e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4cafb97ca3f594ca7050af4399ec3ad80584c6ea703459b76a9a4ed254e2e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d7fd27548c111218a290190fef3d175dd3c370c6172a8a4b40dc4b4e591d39"
    sha256 cellar: :any_skip_relocation, ventura:       "57d7fd27548c111218a290190fef3d175dd3c370c6172a8a4b40dc4b4e591d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1494bc4df83a5d766599f3bae796c6ec4699754b5763a00151e3eff5215c0e53"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker"

  def install
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
