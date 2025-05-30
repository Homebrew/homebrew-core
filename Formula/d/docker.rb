class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.2.2",
      revision: "e6534b4eb700e592f25e7213568a02f3ce37460d"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960354449a9dd1ca73eae7afcce85e9e542431b4b8e6a4fa6ebcdd47b7adfd5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960354449a9dd1ca73eae7afcce85e9e542431b4b8e6a4fa6ebcdd47b7adfd5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "960354449a9dd1ca73eae7afcce85e9e542431b4b8e6a4fa6ebcdd47b7adfd5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "da26027d3fc8d77104bddd53bd946ae871716701869e85f839f777c524e4c6db"
    sha256 cellar: :any_skip_relocation, ventura:       "da26027d3fc8d77104bddd53bd946ae871716701869e85f839f777c524e4c6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21887e7206a795d402ed30807661dbcdeeb1d63776d7c1057580b3f7fc08bde2"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker"

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
