class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.0.0",
      revision: "2ae903e86cab51f694c819721cdfdf5eec693720"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51799520300bb93bf1ae1f57344a883fe7c118952b467d34c2524fe66d35128c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c985dd4972e5d905503cc2294936b8838ea06e07915e6deafe5c351289383c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eba5482ecba08d08f256c313f3253510797574a0694aa60e1d5d853dea4a9f79"
    sha256 cellar: :any_skip_relocation, sonoma:         "78ea960e93a2fde03f6eabc48001f20ff13d552e7dca9280aff6a2617f0bd96e"
    sha256 cellar: :any_skip_relocation, ventura:        "02ab6715e37262dba37bf302e61cf509e0c99468ee3df288041aecaf186c573e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b42247cdca9b02232c03ca5e9ea7e934abf4790ff924235617e65fc369789e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af301b1600937b0077f709fe57ddfc385a84d0d9a876fa6e9402559a6bad1d34"
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
