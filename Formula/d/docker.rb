class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.4.3",
      revision: "055a478ea9010a19d0d4674c0d0e87ade37a4223"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56ee8add6c64bace3327650c24858033e8189394936eca98741d08f30607a7a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf30909e5bb499ace90231f3e78c312c8ce468065d32f2d2f7375f10b4678249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835f96a49da45ef0116b6a7f6b27a612761047bfc19bef3481687a70b8381bcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec0e36d8cd7b7ee0d0169f56a3b67c8145e11e6bc5eb8d7126e626348a390b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af33d0d69024738a873aac06f49970a6a43e2a71da34c8525e62b6fdbc2e59b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "682784cc3f21996040aa5be52f784c0f98de2aa3d364cdb37514d0c5fdc0be04"
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

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
