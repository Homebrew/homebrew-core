class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.4.0.tar.gz"
  sha256 "558dcc8fbf72095aa1ec8abeb84ca2093dd0d51b77f0115ef855e640e2f03146"
  license "Apache-2.0"
  revision 1
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03f38f5d89276c5b448812e4add56822e9e85c912d8fd078d87c0606b781cc5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8bce96d8fd2067f0fdd5ea9c1d6d76ddeb9177cfef3309a85a60013b037e0b33"
    sha256 cellar: :any_skip_relocation, catalina:      "04544f80c3bd97f7da4650822ac0b982335eed1d18032d4e118bd9a181dbdf94"
    sha256 cellar: :any_skip_relocation, mojave:        "e56623493f090b800054d70a611b087528576b3ba3cb9efd59bcd549497beebe"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu"

  resource "gvproxy" do
    url "https://github.com/containers/gvisor-tap-vsock/archive/v0.1.0.tar.gz"
    sha256 "e1e1bec2fc42039da1ae68d382d4560a27c04bbe2aae535837294dd6773e88e0"
  end

  patch do
    url "https://github.com/containers/podman/commit/cd4e10fdf93009f8ecba5f0c82c1c2a4a46f3e4f.patch?full_index=1"
    sha256 "d173f27ff530022244cc6895bfd08fbb7546e1457b2edee0854732200aabfde5"
  end

  def install
    os = if OS.mac?
      "darwin"
    else
      "linux"
    end

    system "make", "podman-remote-#{os}"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make"
      libexec.install "bin/gvproxy"
    end

    if build.head?
      system "make", "podman-remote-#{os}-docs"
    else
      system "make", "install-podman-remote-#{os}-docs"
    end

    man1.install Dir["docs/build/remote/#{os}/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    assert_match(/Cannot connect to Podman/i, shell_output("#{bin}/podman-remote info 2>&1", 125))

    machineinit_output = shell_output("podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
    assert_match "Error: open fake-testi123: no such file or directory", machineinit_output
  end
end
