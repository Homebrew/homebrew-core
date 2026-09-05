class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "a99a4dca98061064ff4cb35d27d1ec2345717e9108c822329fcec91dc72bff96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cddde009e8c412b480ccf455fa3652e811bcbc63b0ffb4d50f30bd8e319d1a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083f8564098c41152e660da9fb41e057bb66d4c54be9c3ff158e87580b0fef71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8633fe93ef7919b81ce9793ce58a5493db8792b684fec3f7612a0da204eb086"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a5611daac5239995dd2f5746ae905cc95f96e6e9a5e519c472fef1f0774542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1831bb7f96052a1775c0d82f46b9dba5f0c0fedc83b4fb34e74f1c5add9f375b"
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
