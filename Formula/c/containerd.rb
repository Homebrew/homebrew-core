class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "b97780bde4b01ed3596b0b0c6f55bfb130794a3db4e6fe2e0fc9719244933945"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc9ae1225ac8f3e0f9e8eb3726326eb834ecd83f653c68c2fd7a886de8aa25d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64a324b97a3b2a2a0c1fc564ebfd93ed0c69a15e32e10e5321db0512a718ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba6b458524a91e1e1c8dba4870c67fe2d5530b4a27d4b2097116f8cb6fe61ecf"
    sha256 cellar: :any_skip_relocation, sonoma:        "627d6c3c45ae73f03598040f018f7130e063fdd5d1c18159df2544fba04d6712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "468a8911443eca43676417abed4ffbc12f6b00b4119430317e52679b870f734b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d07bbce3d39ad3d956241b8af9c8f8a36084e5a52b680b1e74f81559f287c9"
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
