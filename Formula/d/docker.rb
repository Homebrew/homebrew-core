class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.6.2",
      revision: "dfc4efb1e2ab8c06d70d2a1366ad448d2f917e90"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b05a401b661f2d0c3b54b10fd1e0c4adb26b479dcfb953d86febfdfb57dd9821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7cd1bf7006404d5095b70bcb1caaa7b0402718da1216ce5de2b0e516a5906e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48491fe963c80dcd00447b743a993149deaf45a4b4193c6ad4c411b3ab2e9718"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e0df28af15346e1678b8d2bb0457b447427f5065be86a3dc56a7c048bc0fa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eddd7b9c2abcce7fb47cfa789734f95da9045017f8f580596e28589491892b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feeee461a8fd680cf1c9645d24d03148886a3d517450e905916d659b083d3b48"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

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
