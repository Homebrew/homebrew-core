class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "fcff2096ef20f1bc1d939bc55a8b831ea3eface574463fd7dc770b33ffe317b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436a6271553eeb8bb6ba8f904506807e9825d6ad5f7bf5c41fbe88ceca78ba95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8e80b0bf084f4d2e7ee88417a439a619aab0d9d48ac16cb1fb70631a3d7b008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f792e436f04b8fb0ff5de69f3de4211f6f08a041bfa5e7622662c09cc15c061f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81ecacab44e3726ddff20bc17a666b61183862628a9c8b388afe8c47602f997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f8c96cf11eedd497fa5855b038d316debe0a951f0f5766f3b24d30bab94c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0e86b3957a9556ee0bd99e818796c0378f8497ff2894582f5ddd0223694cba"
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
