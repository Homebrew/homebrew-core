class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v3.4.2.tar.gz"
    sha256 "b0c4f9a11eb500b1d440d5e51a6c0c632aa4ac458e2dc0362f50f999eb7fbf31"

    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.3.0.tar.gz"
      sha256 "6ca454ae73fce3574fa2b615e6c923ee526064d0dc2bcf8dab3cca57e9678035"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64a1591367db067b9cf41f0c6957e2922a5febe39a35ae7a73598c69e8c95ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "023c0a4f1a447396a551a5a84acc87990aa822ea3c813a53325bd69cf7e5759d"
    sha256 cellar: :any_skip_relocation, monterey:       "6c8c7f789171738bf7207dc4bb66e1d7dfcd8ac8fb4d04aed024e3e2d9e72805"
    sha256 cellar: :any_skip_relocation, big_sur:        "5da22da01ec400bf0cdb3ce6f4ff583d0ebb8655e659e48f15aedae1b4249e97"
    sha256 cellar: :any_skip_relocation, catalina:       "c92229e39cda40be6de7f98d8291420f87e186a4d84d10026382fd77d5b71c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81c5033f148cef53d8b725e51931fa29860fcb0a0e2f53f1c0ff149ef48d36e8"
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
