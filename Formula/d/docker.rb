class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.5",
      revision: "ced099660009713e0e845eeb754e6050dbaa45d0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535cbf2123170068ee315fdf5e8ceeacedc22e9a89cd17d45d2194b07dce3ea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "535cbf2123170068ee315fdf5e8ceeacedc22e9a89cd17d45d2194b07dce3ea0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "535cbf2123170068ee315fdf5e8ceeacedc22e9a89cd17d45d2194b07dce3ea0"
    sha256 cellar: :any_skip_relocation, ventura:        "25a7049a99a9a2e8a9729a2884a177e5fb692f160efd07db5be26a44d5174c66"
    sha256 cellar: :any_skip_relocation, monterey:       "25a7049a99a9a2e8a9729a2884a177e5fb692f160efd07db5be26a44d5174c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a7049a99a9a2e8a9729a2884a177e5fb692f160efd07db5be26a44d5174c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f5da4e794d1e8f83fd68981116896cdada3b0f8884bd868046e03c6159afe0"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

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
