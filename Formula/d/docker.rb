class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.6.1",
      revision: "8900f1d330cb39e93e16d780a26bff1d7e07ba03"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f28d2c846ddebabd52587d4efc7ff964f5a0d46aa80822bbc4e8c49d2cdd6bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "228eedbe1017a643b517db9b9bdd4216b769710e8a53284b5d8118831d2c736e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1602bbfb2607d5c1e9d12e2f3c96635db416f151f9c3a6ac4352b6af73f1fe40"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3021430860d590f2eb825ad316e32538dc8ff7dd107b24a5a21fb12784b1936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa19a2088cec13816c773e414c40484c245bd7dc47b57775079125920aa6d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e4a525b48a5982760985c286de97d6e0a0c8aa903c7679dcb7148467064d80"
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
