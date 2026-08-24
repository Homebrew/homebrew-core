class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "175bbf57d637c987fa742f846b43b1b8ba2c61af6a9eaec619c625e4a8a19b69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d04f4fa6e3fd35d72d2db475b545cfaea441aa2283cd878c375c81fdeed123ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b8de2c1761738e0111199a5e21570fc884e6c2e7c12621120d5117e09726093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e4267fe530fee37ea23a5cef4c05c336f16cde39da62082c16556d9f8d22e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "85fdb5df301f875c1ef404d5531015c65db8277a103e07bd3841d93c29277c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c82dd6cedbecf057def4fdf482a131ad2f0a114a48ed9f82f059cf45baf915cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92398d2492a1c7a736830283af9f60c3f5f928d184324cb7d27b782ae0765680"
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
