class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.4.0.tar.gz"
  sha256 "558dcc8fbf72095aa1ec8abeb84ca2093dd0d51b77f0115ef855e640e2f03146"
  license "Apache-2.0"
  revision 1
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c1971da4589087f2180fa49b40c851fca4c2b9bf593bd44dbe3f4e58cbbe10b"
    sha256 cellar: :any_skip_relocation, big_sur:       "65b993ea6b0768a9c29501817dd8211d04171f47cb3f8ab58f25bbd63020130a"
    sha256 cellar: :any_skip_relocation, catalina:      "11df26e48c1da4e2d2d89b32a4b7ac9d80d409df7efbe8f47a5547973924c980"
    sha256 cellar: :any_skip_relocation, mojave:        "5b324a8a7408e4e9b52312af265ac244356e09f230288a45cea060cd1f086be5"
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
