class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.0.2",
      revision: "8108357bcb4b5d746ccc44aa85e60995895b26b3"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "796a71b87b7e4e7e75e2f53905c50e772ec31f0539126b70c0404141fe7d9e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ff9c75170ba9765b22527dc889e336a2383776d590d35058b546162119a67c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b6563dfcc95abf647e2ddcdd1e6ee0399ba3ed16b5c077d55512f8b9b3fb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e382f7d4e8b3b32f88da7d4e597ad5af78483efdd03f5762eb11b2f64cd9f6bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41583be2f3aff350d6fa674dc02f5c911fad299f4634c035cf65be1b1ef447e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad029d5e14cd938de0ae7c96f553ae5ac4d501ce80c782cfec18270b89fc0774"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
