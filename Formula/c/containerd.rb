class Containerd < Formula
  desc "Open and reliable container runtime"
  homepage "https://containerd.io"
  url "https://github.com/containerd/containerd/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d6e8e6424c544cdab9b51cae320c3a9aa5590e8e1ffbd1f862eb395fd8c5bc28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977da814d036ead085a554b6de264c172f9600d598708addb546be3516bd036c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d1a3af087a7e5c3f450787cca257480f7eb4bafa3e19006988ae90ac251485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4ba8dd3c76e2e4df4cf99a7a1adfdf7ccc0503694e412c729d4d8572a00bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b7fb1d21ad480e491a3fc771010888ea3d6d9b6585b7b2dae02993f4fe5d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f7e968a69b5192d188220a2d0065eee32d6b4a7b1ab1fce8596777f93c3739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c595c679fc7e78c60124f095d143222b99a433c409330e1d6512b3691e20a5d"
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
