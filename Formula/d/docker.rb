class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.0.4",
      revision: "b8034c0ed70494a90c133461d145cd072d920d7c"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d179df1d2e67d317743aaf177397c73570e84e14ac6b2d3b7d5e39a5cf8c0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d179df1d2e67d317743aaf177397c73570e84e14ac6b2d3b7d5e39a5cf8c0a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d179df1d2e67d317743aaf177397c73570e84e14ac6b2d3b7d5e39a5cf8c0a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "881876f98098a12ec8af810401738be89d1d65aecc8766d269e2f40f2fd821c7"
    sha256 cellar: :any_skip_relocation, ventura:       "881876f98098a12ec8af810401738be89d1d65aecc8766d269e2f40f2fd821c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6bcefd31a370efcda1817742be32f0cf21cd1ae650946a3ac3e55a2670730f"
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
