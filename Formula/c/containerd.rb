class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "1a215ae4acb184192668b21f8b8375ceb6e86f8832a97fe6f7ab53ad79bb2cee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9669f95bf6b9b618de2da1ef09fb53ffd47bfa769cd912ebc91d53ecdc7bc5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18cfdb04239a96658058e62eab959c3ae006068b9dd409e90db972a4e007a082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51129c0fd80e4baad595676cd8ec3039e072deb45cec6af58730b9a6174ccc60"
    sha256 cellar: :any_skip_relocation, sonoma:        "728b7748e7d40116a5383ba3610f7ac91728fecb62a4e3a7b923ebbb550436f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67911af8ca8f6bfff3d52b17717a63bfe76f974ab5e369abcd555d522b9ae2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2145a82d90ac9678b3f3e9a530de0748e574bc3c9512fa5f0c42a07af86a42b8"
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
