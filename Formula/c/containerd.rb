class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "02cbbecd0ef78a521d124afa791b843ba5458ef206e1f7f017999ff45c80c0b4"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc4aab39c42519f1bef0559850f778e44387a6ecaeb6bff13cf33005b6caaeda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f073e764d73493825dcce277ceda20325960d37334a7fdc64adb0d8edad1acc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "507dd8b44f657a3ccaf2f8029e50fc9e5429462be4d7dd4e848af80c8ab91e16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e2f2d804f9caa23429c170b45cfd18f6c04c47ea64969fd822f690754dd9f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7700772e9daad4a8dd13443d2552ce2e21c36d268dffbed1ae0cf65bd1abe7da"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
