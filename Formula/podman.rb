class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.2.tar.gz"
  sha256 "70f70327be96d873c83c741c004806c0014ea41039e716545c789b4393184e79"
  license "Apache-2.0"
  revision 1
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "008a58362b3a64fe9a69e2ea314889121d9a19374506ce20bcfabe558a9e6026"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6905ded224f524651c3e57f1b1ef830a40309b25a511de43b4d0122d94bb2d0"
    sha256 cellar: :any_skip_relocation, catalina:      "bbf866a98e35c63ad0f572061850cc326e2d5ea1194b478d00a25fcab7f20698"
    sha256 cellar: :any_skip_relocation, mojave:        "7609e7f56571792255f1e2db2dfd55e72e16f4d9fdb9dbd15f664338a762533c"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "qemu" if Hardware::CPU.intel?

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/darwin/podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
    fish_completion.install "completions/fish/podman.fish"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match(/Error: Cannot connect to the Podman socket/i, shell_output("#{bin}/podman info 2>&1", 125))
    if Hardware::CPU.intel?
      machineinit_output = shell_output("podman machine init --image-path fake-testimage123 fake-testvm123 2>&1", 125)
      assert_match "Error: open fake-testimage123: no such file or directory", machineinit_output
    end
  end
end
