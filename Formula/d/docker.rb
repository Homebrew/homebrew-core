class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v25.0.5",
      revision: "5dc9bcc5b78ed23f12cdd68e4285ea1c216ce2a1"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b95b1673b5ff63e01ee164c6fde1c022e80a4f01cc57f89360300e6f8dc47d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f9c976ed1c83c4080ae998622cd5235d0a489d22fd6ce3300c6e49c58b55f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb7f898f1fbe21f157c0252457376050940bf9cfa9b391e3eed09916d3478a9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c49f3e68c9fe7e8e87295073215c9cfd9175d2fcc72ab4d93c00886807354837"
    sha256 cellar: :any_skip_relocation, ventura:        "187dbe2248c6e140ac1bb27ca7ba7877ead154ad41757404c55584b74ebf2183"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9bb7844614a21943c4f1aef4e42573ae3b4dd3beaf27de8a5d1a7c90f55c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd2ffbc42e1c1408af7d572282163dedc786755d229dac95be24d9d2fea42a47"
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
