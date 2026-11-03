class Buildkitd < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit (Daemon)"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "e9d5867e1f973ff13f46509172cbdb22c3acf8f1867215bab31d95d37d67964d"
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
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7517e0573eeb8ad2a96f61f7053e5ec05b166f4e6116b7c2748897d9ff795ffa"
    sha256 cellar: :any,                 x86_64_linux: "473c485cda3c5ad58b3dac097c2db5062e3a1b65b110d9edde3cfd07687f3acf"
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
