class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v25.0.3",
      revision: "4debf411d1e6efbd9ce65e4250718e9c529a6525"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d74c65d2f2fc92a35c544e32d30955f542d3f1a1aa952c7fc4b2b770134deecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f42d4a5922cd9d45140836fba73ea52481c382213bd3ef8b5b710361fcad9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e767ffb8c739e9c940335076ec4d656630c1138c6966a85fa2838ea86a2fd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e05971c6fa7e4f7d11e91f116a4deb8edde03859e463f539ca5d4e36b489e345"
    sha256 cellar: :any_skip_relocation, ventura:        "749dc01ef7c504561e438d0f0b21663349af69e567573c0a91e04158d391ed64"
    sha256 cellar: :any_skip_relocation, monterey:       "8311c765f8ec60726aa9d0b2993e8aaa621a9b089d392e9844ffc905ccffc951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d397e666377ef1d2ad53dfe392daf37fce9155caa9fad344a0f94d906881096b"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

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
