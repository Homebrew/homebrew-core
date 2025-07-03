class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.3.1",
      revision: "38b7060a218775811da953650d8df7d492653f8f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c95fb6f394791abf5157830f11dfbb9c2fc11633a908b962eddcba036e78ac8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45731be257bedf5a08daa9f8edbfca3bd3a72e2ff38e81ead4ba44455dfc071d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb2425d2e3f101982e9864f623f3ccb4720420343c983127fbd0da612edc1cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8c7006859d506952902abb52cd679c33bc86f73c476139ed0b835bef2582325"
    sha256 cellar: :any_skip_relocation, ventura:       "288c96bbfb5b52cffbc21838505523af632336bee498d85739afbb27e73d87b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9ebebc4b073a0c30eff765eab019cd81de26fa8c70bd9cca4cad09f534a582"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

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
