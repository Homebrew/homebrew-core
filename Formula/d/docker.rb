class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.5.1",
      revision: "9f9e4058019a37304dc6572ffcbb409d529b59d8"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5adc3aaf3292b48e5c596768f4e8d43eeb04a7e7ff24dd0e2f736e01792d514c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5adc3aaf3292b48e5c596768f4e8d43eeb04a7e7ff24dd0e2f736e01792d514c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5adc3aaf3292b48e5c596768f4e8d43eeb04a7e7ff24dd0e2f736e01792d514c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d051a7f59828790a93094cd3c71f4c390d730e4bd9d23640f06e03127864ce"
    sha256 cellar: :any_skip_relocation, ventura:       "f2d051a7f59828790a93094cd3c71f4c390d730e4bd9d23640f06e03127864ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be30a572bb295aa2d7b0b32682a8c721decf3f913167bbf81158366db569c39"
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
