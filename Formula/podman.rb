class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/containers/podman/archive/v4.0.3.tar.gz"
    sha256 "e3b53fc9142d4f2dc085f17a377d92ffb8bfe7756c4f47b8128b38bcc3540cbc"
    resource "gvproxy" do
      url "https://github.com/containers/gvisor-tap-vsock/archive/v0.3.0.tar.gz"
      sha256 "6ca454ae73fce3574fa2b615e6c923ee526064d0dc2bcf8dab3cca57e9678035"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1b7e427ca2bc38957a4455e1beafeb42df4f454e4720d80c5e08df99d490c11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65c7531cede713e450859f725b709ab684b9e2b3ac53e2a09284538728046d61"
    sha256 cellar: :any_skip_relocation, monterey:       "a69aa668172be5b2870da5bb45f944baa4c2b1285ecf81ca8e7cce46b39b8260"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1bfadd2a72a22c889d186e3323e6b5606ff0255ae77ae6030cb0433c0875b7b"
    sha256 cellar: :any_skip_relocation, catalina:       "52859377261c37ccd6dc1cabf4f1e8d07618e4942d82da4c641a842967c095e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7625c294d41ea3d920b847539abc0b2210559b9f663b9a14f769897c28c02164"
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
      bin.install "bin/#{os}/podman-mac-helper" => "podman-mac-helper"
    else
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make", "gvproxy"
      libexec.install "bin/gvproxy"
    end

    system "make", "podman-remote-#{os}-docs"
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
