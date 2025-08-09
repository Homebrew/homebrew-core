class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v28.3.3",
      revision: "980b85681696fbd95927fd8ded8f6d91bdca95b0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4556f02e4a6768d151f6e4c63dc44ecef119bb46d1a982d471cdf0f87db5ba5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "115483cd3eb1d4d020ff5888b055894dd04923d9f049e1331c21fa4650ae914a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30caf140e39b337144ea14420fdbc4c420d603825ddeff32c662fb1fd28e02df"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe557328fa37ccdd53fefb64cebff6bb4499eb746c73f6453d6beb489468efa"
    sha256 cellar: :any_skip_relocation, ventura:       "ce4db52fcc9a721ddd98425cd265ebd90ed2b746ec0534e09b9e3ba9b40d747f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa01d71b4a5dbc82addedea0b79836a315200a3bd7b061a5ceb395a4db37e571"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

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

    # FIXME: we shouldn't need this, but patchelf.rb does not seem to work well with the layout of Aarch64 ELF files
    ldflags += ["-extld", ENV.cc] if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :fish, :pwsh, :zsh])
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
