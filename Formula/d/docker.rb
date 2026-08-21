class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.7.2",
      revision: "a7dcaa6fdb6ed04aacbfdc76357fdae01605609e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b061dbca62960f6bbf16b983b156cb960bf810e678e14c6bd366b58506eb4f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad069f0ad9f8396362a1c8d5bd8d6e764e0ed5846f31366346d539c377480bb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d409d0b8e1824db53a2348dd11ace24dcf03e794a11b144ea0458dae26c3110b"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e117e3b7892b9d5404dfc4361a976a3d3801f3722d4509b23538780a1d8b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2709b1c25296e3f150204c9f7547e2c6ea322c49d16aeaaf3deb9a6a4daed99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8c811bfc6bad2e27e2a1b812a8e66aa6f93fe3335a0e7c82aabc689a306472"
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
