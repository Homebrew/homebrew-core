class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.1.1",
      revision: "4cf5afaefa0bec8ab94fcf631add24e284d0ecbf"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0ff46ca011c29e9db28b35fa98be3bafb375ca2d47c6a5e64197b7953d32f24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0ea96247cd0a321f5453adeacd1d27a86fbba236c0da7b745711db04c5add9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7896ccbd136fc29cdb912fc3bd744b9aef832922e5262842b5d6e35c01e2213"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a859b98e4747c01c7373f6ada98bf4c42c8b77bda2bb320a03368e0be468d96"
    sha256 cellar: :any_skip_relocation, ventura:        "0500ad671c48d05e5ddee6d1343d94066f0f68dc7c1d18f511961b4ec46a13b7"
    sha256 cellar: :any_skip_relocation, monterey:       "22f90d31e1d14d7bf691beb914a2c3dc707d866329fad95bae7452bed2a2d738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b673624f638e9bee0cba6cc6fe4f9652385c81f61383a2a4b79975ec8ec5b6b"
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
