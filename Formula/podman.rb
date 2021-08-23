class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.3.0.tar.gz"
  sha256 "b92c308471d825facb408e72691f9a62441639f1b1c552efab1645bc5bd3f91b"
  license "Apache-2.0"
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5fd91154c325f6a9bb7fc32bb9ede9a86ed1bb96997c973a32909c54152270d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f46857b1181d4cc3000d47c00e214a8902b4607c76c7a36d3a0accb7a2a5d72"
    sha256 cellar: :any_skip_relocation, catalina:      "a571eb24035439967e96ab3d053a6b2ce9c93510720f7d07e8c101fa9cfc9352"
    sha256 cellar: :any_skip_relocation, mojave:        "cbd50cf21d05ce5f12e5010ac40822dc33aab2b5c40b25430e926a613a23a243"
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
    on_macos do
      bin.install "bin/#{os}/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"
    end
    on_linux do
      bin.install "bin/podman-remote"
    end

    resource("gvproxy").stage do
      system "make"
      bin.install "bin/gvproxy"
    end

    system "make", "install-podman-remote-#{os}-docs"
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
