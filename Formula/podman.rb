class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.0.5.tar.gz"
  sha256 "cd7618429f02db8e7dbca29c6f8a7623a91a01804ef768dc5ec8c7660679b0c5"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    inreplace "docs/remote-docs.sh", "sed -i", "sed -i \"\""
    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match "Error: Get \"http://d/v1.0.0/libpod../../../_ping\"", shell_output("#{bin}/podman 2>&1", 125)
  end
end
