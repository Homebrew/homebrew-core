class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.3.1.tar.gz"
  sha256 "6e3c57f5fd4199bc7603effb8c34268ee7f65fcd30c7b0d4778396b69388ae1f"
  license "Apache-2.0"
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4f84427f1f207d67376b51cd9ca9c0a07b1f20e2bc82b7d6d1ae0beadc4d46f"
    sha256 cellar: :any_skip_relocation, big_sur:       "08252d0ef5eaa0989f1d23dcb7bbc95191dd8f0239acccab48bd1b2bd653a40b"
    sha256 cellar: :any_skip_relocation, catalina:      "a55cf51bd3b34b60c9acb8a5da5a635a417cbfbf5d9486cfa62e9e0ac0d7cf61"
    sha256 cellar: :any_skip_relocation, mojave:        "cf84801df11145814e68d066ef971c34e8c18c9791a7ea9f15230ccbabc6a5ae"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu" if Hardware::CPU.intel?

  resource "gvproxy" do
    url "https://github.com/containers/gvisor-tap-vsock/archive/v0.1.0.tar.gz"
    sha256 "e1e1bec2fc42039da1ae68d382d4560a27c04bbe2aae535837294dd6773e88e0"
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
      bin.install "bin/gvproxy"
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
    assert_match(/Error: Cannot connect to the Podman socket/i, shell_output("#{bin}/podman-remote info 2>&1", 125))
    if Hardware::CPU.intel?
      machineinit_output = shell_output("podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
      assert_match "Error: open fake-testi123: no such file or directory", machineinit_output
    end
  end
end
