class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "01b8974eac869ee146b510af13b56653e4c3da16aa71342dd3ba244c1ac01ab0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e94eebb687355336d4bf29b816203b72a4da365a41956811d4c2df6eb8fca623"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf3e87b9bbfbed99dde475d0ef08270910e28ec33da043e1e5add735f0d281f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bfb08f58ba3ffc07529092d1a21f91ebd9f7de4448417270e4259b8738790dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83fcbe6ded475ad0ecfe69a2d1f7583c355e7f6f6d0d8cb77e3545eac3b0c847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8d7b705ef2359eeb4c372cec5fb0f60b8e68cde03b9dc479978c96087ed346df"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    args =["PREFIX=#{prefix}", "VERSION=#{version}", "REVISION="]
    # STATIC=1 is a workaround for the segfault issue on the Linux arm64 CI.
    # Not locally reproducible.
    # https://github.com/Homebrew/homebrew-core/pull/269867#issuecomment-3977167831
    args << "STATIC=1" if OS.linux?
    system "make", *args
    system "make", "install", "install-doc", "install-man", *args
  end

  def caveats
    caveats = ""
    on_linux do
      caveats = <<~EOS
        For most workloads you need to execute the following command to install OCI and CNI:
          brew install runc cni-plugins

        To run containerd as the current user, execute the following commands:
          brew install nerdctl rootlesskit slirp4netns
          containerd-rootless-setuptool.sh install

        To run containerd as the root user, use `brew services` with `sudo --preserve-env=HOME`.
      EOS
    end
    on_macos do
      caveats = <<~EOS
        The macOS version of containerd does not natively support running containers.
        You need to install an additional runtime plugin such as nerdbox (not packaged in Homebrew yet)
        to run containers on this build of containerd.

        To run the Linux native version of containerd in Linux Machine (Lima), execute the following commands:
          brew install lima
          limactl start
      EOS
    end
    caveats
  end

  service do
    run opt_bin/"containerd"
    # See the caveats for rootless mode
    require_root true
  end

  test do
    assert_match "/run/containerd/containerd.sock: no such file or directory",
      shell_output("#{opt_bin}/ctr info 2>&1", 1)
  end
end
