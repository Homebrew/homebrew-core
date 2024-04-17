class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.0.1",
      revision: "d260a54c81efcc3f00fe67dee78c94b16c2f8692"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c71666b137e3f0a282d6f08c9969e6806c01266a136cd386c7b2219961af2f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca333706700a16f5a73585da1756d130c54ca63c2001047c8976f56a85999850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c656fd1737c95051d21d151e2a772d2c896a88160453b72bda1ec04db2894b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b776b8add72f700c01ce67ef9a2258f80dfbfd5e84f043386df6cf157c0c6e6"
    sha256 cellar: :any_skip_relocation, ventura:        "c66b5dcf36d49fc005e991248a34df73fb0ecaa8a8a41923e2b3ed91dcfdd99e"
    sha256 cellar: :any_skip_relocation, monterey:       "757a9c57c4854e6ee4bb6a31ed493dbc7cfb80aff598cb3ff19b6b3c8f535edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efd464d5f12f97af650315f9d08d08f2256beea7f59863d9bf0f0e4cbf64cca"
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
