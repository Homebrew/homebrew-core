class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v3.4.4.tar.gz"
    sha256 "718c9e1e734c2d374fcf3c59e4cc7c1755acb954fc7565093e1d636c04b72e3a"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.3.0.tar.gz"
      sha256 "6ca454ae73fce3574fa2b615e6c923ee526064d0dc2bcf8dab3cca57e9678035"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0def2137482d85b70ed15478baec72c7d206a2aae463e83c6bae34eca41c8544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d06af0a762188e3935c3e60855960a7b31e5ea7422ccb815c1febe789a65de96"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7b2ff73954c3e054e2ccf443ddcb450f97948e8a49b9b5521d473ed8690a99"
    sha256 cellar: :any_skip_relocation, big_sur:        "693e5b69df92a49cc5de6230a5d1a034789b0256e8118ea91b2a97fc90712ff8"
    sha256 cellar: :any_skip_relocation, catalina:       "15feee7bfa75af1aa45c54cfb968a8162c74e274f69f13cfdd3c61cbf85f8f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4260f12f2d0212942f3bd869dac8e0a9d0c03db77647f8ec7e5c3292b1a4c5d5"
  end

  head do
    url "https://github.com/containers/podman.git", branch: "main"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock.git", branch: "main"
    end
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu"

  def install
    ENV["CGO_ENABLED"] = "1"
    os = OS.kernel_name.downcase

    inreplace "vendor/github.com/containers/common/pkg/config/config_#{os}.go",
              "/usr/local/libexec/podman",
              libexec

    system "make", "podman-remote-#{os}"
    if OS.mac?
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make", "gvproxy"
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
