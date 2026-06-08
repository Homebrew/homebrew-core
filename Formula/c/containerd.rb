class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "9de4cb8bfb27964a8ffd95e35326b7279ea2e2a6506da16c2533d3f523f12c11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c0d3b6acd131b659ec5d3c7a4a3c763abc1c30fc5e177e193329fbe4f61fe6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a0a09f45622db71e8849109a26470f8699e060675930760b609b4689936904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6415a8add4ff3bf9383d517ba5ac4c063ebad85465d03c64569ff6d175e20005"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67004c216ff7a439fc844e19ea68cb7f311bc0147b3791487387d276e362117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dcf2902fe0488b4dc34f0f3dc8050b67b48d7dc2bd0e5cd1bd6e06c5acadc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a10042980c48847029ac31fc0522687a2b850dca8834d1893a077c811541db"
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
