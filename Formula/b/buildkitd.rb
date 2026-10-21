class Buildkitd < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit (Daemon)"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "0f7d4a765b273359d0752aa1c8a309606578fd0db42e71f0fc5de845d3b1139b"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0bfb3eebabb37ecf2d08fc6c06ad156fcd3e21194ca6c36adfd6f035a3b55dbe"
    sha256 cellar: :any,                 x86_64_linux: "e204407ef88c4fcbc5ba4ed649e85ed0dcde58762d633ae9938e1ebc17ff7f1b"
  end

  depends_on "go" => :build

  depends_on :linux
  depends_on "runc"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildkitd"), "./cmd/buildkitd"
    # Docs are not installed here, as they are already provided by the buildkit (client) formula.
  end

  def caveats
    <<~EOS
      To run buildkitd as the current user, see the following steps:
        OCI worker mode:
          brew install rootlesskit
          rootlesskit buildkitd
        containerd worker mode:
          brew install nerdctl containerd rootlesskit slirp4netns
          containerd-rootless-setuptool.sh install
          CONTAINERD_NAMESPACE=default containerd-rootless-setuptool.sh install-buildkit-containerd

      To run buildkitd as the root user, use `brew services` with `sudo --preserve-env=HOME`.
    EOS
  end

  service do
    run opt_bin/"buildkitd"
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkitd --version")
    assert_match "buildkitd: rootless mode requires to be executed as the mapped root in a user namespace",
      shell_output("#{bin}/buildkitd 2>&1", 1)
  end
end
