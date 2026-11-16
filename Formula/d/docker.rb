class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.10.0",
      revision: "fdd4b8e5da335e1d0d83d29af5045f57280cd694"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53c64a0a7c02f196a4878623526a5e726af68c77881f2dddc26ec6612c96680d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c59ba25316e8cdcc45edb5268916a582a078a272a0fa9f6d1310f54314881b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eebf58000d5c24afc8e2ca00fb54279695c82225b03d3d9dc62b443fcd24ba4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d64c141144b503784916d79801fb3e33a3a3c520d5168a68714f2d359c94cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b866fbb8943f60449fafda27f6ed329992f3b2575be42772c1888ecc8077d878"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = [
      "-X", "github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}",
      "-X", "github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
      "-X", "github.com/docker/cli/cli/version.Version=#{version}",
      "-X", "\"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
