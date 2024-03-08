class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v25.0.4",
      revision: "1a576c50a9a33dd7ab2bcd78db1982cb965812b0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d9125c097d3475120e270b4e7a27963af2025993f88af9436caf0a1c853ecca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d040e18e530ccd34ebca8e5d1f8f593b380ae853d425e40a6440bcdac57631a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb2c11f716787c8b180a053ae0e6bb8bb869cee9deb27e9409f6becf7a3b5389"
    sha256 cellar: :any_skip_relocation, sonoma:         "8af7109a01778f5532c74a6b49a66f748ca41ee2782f19fdc485ee1a9f11ada0"
    sha256 cellar: :any_skip_relocation, ventura:        "ccb2122276fff9028676c4a885bec346ff6f2d9963d8ad6eab1a49d3bcac4125"
    sha256 cellar: :any_skip_relocation, monterey:       "e40a8a92f25684d2533c6f24c7cfc8a658e7bb921fde8d4bd5b40aba152dfe33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66386a0d3539485e6ac38fb0679e78b39836729b7d3e3f2ea9a538c35adf80e2"
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
