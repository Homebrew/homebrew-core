class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "915ef1d9fab5fbd8e3726bfb80c901fd87aa25e938bed5194df132853036ed58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c647cfc86ae02f4d08f039780cff62093504f2204bdc82a78bc7a81ae00aead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a907435c3ca44008d0d01c6f6563f630a4ad77faf084d81694add41dce99767d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad552ea344215baa034e64ba2ad97e3ecd486c0ceaef0540d525b3adae0156b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d7231481827ddfa01ad8b7f11ca15b49a30029784d099a36332f393e894c33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c3d703a28a0d10c33809b55ad114f3bfffce592229ce02bcfc76c1171a2a050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d056002e8cf09001412b40bc8a1b5276a478ec82d54ff92d1620a37478f43c34"
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
