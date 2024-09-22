class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v27.3.1",
      revision: "ce1223035ac3ab8922717092e63a184cf67b493d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd25100f823e80d665ce0bed51fe5016a4839669cb8bbfbb2e5be0e26dcc545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd25100f823e80d665ce0bed51fe5016a4839669cb8bbfbb2e5be0e26dcc545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcd25100f823e80d665ce0bed51fe5016a4839669cb8bbfbb2e5be0e26dcc545"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ce47ef4f6ad9f17ac563ff39524beee77ad1b2baab58a4d4cac62b56367ce6"
    sha256 cellar: :any_skip_relocation, ventura:       "d1ce47ef4f6ad9f17ac563ff39524beee77ad1b2baab58a4d4cac62b56367ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9af7f20c3d2b82d2146ffa6e1a524edfe8afc28251e4ed2dcbee01fe13f855"
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
