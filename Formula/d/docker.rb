class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.1.2",
      revision: "211e74b2407f24fd305907c8f90430a9f465df66"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a7b36ac327680e1589f3a1a246d62d48d4a8512387bc58fa13243ddfcedd6b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0484a11bd3e8b984ada192372d113d402fd020dc5672885b3a45b879b7889a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27f64408f74fe6f371c9c7ba7fd8cdfd262d5ca1584bc598a607ca80dee509a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3117020c5db9d6d839f126ee1519e414b5b63c9e38f164da4cad74c14546ed0a"
    sha256 cellar: :any_skip_relocation, ventura:        "a389d4820038dc122c725fe9bd8ee3de6ebab41f62efa81b68b41b322b5c59d0"
    sha256 cellar: :any_skip_relocation, monterey:       "92a5b660568174a521d04311d869dd62c850cea0b04d66cf4ef8e858f5752eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03fb33b90ee70dde537ae1387e209fc828d0afb174818d1699806bb352208dd9"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

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
