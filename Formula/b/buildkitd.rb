class Buildkitd < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit (Daemon)"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "2307112b30593fb8fc4d479ce4547862fa101fa2ecd50a852330a1117a988bbc"
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
    sha256 cellar: :any_skip_relocation, arm64_linux:  "aeef826aa5ac6bba845296fd2aeb5fb7c8b32cf455ad85023e65e15b7354758e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fb0f2ad2f794821947ac5c76d7cbd80aa7d9d965e0c3d52f53ba7c5f7df1a005"
  end

  depends_on "go" => :build

  depends_on :linux
  depends_on "runc"

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
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
