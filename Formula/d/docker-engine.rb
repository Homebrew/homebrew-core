class DockerEngine < Formula
  desc "Pack, ship and run any application as a lightweight container (Daemon)"
  homepage "https://www.docker.com/"
  url "https://github.com/moby/moby.git",
      tag:      "docker-v29.9.2",
      revision: "0367cbeb49b9d98cb0b4f51e95f7b54b4803e76c"
  license "Apache-2.0"
  head "https://github.com/moby/moby.git", branch: "master"

  livecheck do
    url :stable
    regex(/^docker-v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "26911fd445eec7e188e606ff75f07505db8b72cf08ac496e0d40548f8bf3ccf6"
    sha256 cellar: :any,                 x86_64_linux: "c2a2c6e4ae5a88487534b17364e2dd8785c48290658973af5ae69e54ef3a07dd"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "containerd"
  depends_on :linux
  depends_on "nftables"
  depends_on "runc"
  depends_on "tini"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/moby/moby/v2/dockerversion.BuildTime=#{time.iso8601}
      -X github.com/moby/moby/v2/dockerversion.GitCommit=#{Utils.git_short_head}
      -X github.com/moby/moby/v2/dockerversion.Version=#{version}
      -X "github.com/moby/moby/v2/dockerversion.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(output: bin/"dockerd", ldflags:),
      "github.com/moby/moby/v2/cmd/dockerd"
    system "go", "build", *std_go_args(output: bin/"docker-proxy", ldflags:),
      "github.com/moby/moby/v2/cmd/docker-proxy"
    bin.install "contrib/dockerd-rootless.sh"
    bin.install "contrib/dockerd-rootless-setuptool.sh"

    man8.mkpath
    system "go-md2man", "-in=man/dockerd.8.md", "-out=#{man8}/dockerd.8"
  end

  def caveats
    <<~EOS
      To run dockerd as the current user, execute the following commands:
        brew install rootlesskit slirp4netns
        dockerd-rootless-setuptool.sh install

      NOTE: As the lifecycle of containerd is managed by dockerd,
            do NOT run `containerd-rootless-setuptool.sh install`
            before `dockerd-rootless-setuptool.sh install`.

      To run dockerd as the root user, use `brew services` with `sudo --preserve-env=HOME`.
    EOS
  end

  service do
    run opt_bin/"dockerd"
    # See the caveats for rootless mode
    require_root true
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/dockerd --version")
    assert_match "dockerd needs to be started with root privileges",
      shell_output("#{bin}/dockerd 2>&1", 1)
  end
end
