class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.1.0.tar.gz"
  sha256 "60031aa620cbfab641ffef9cb4e68240a0383c23ffd0276938684e98794bb5db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52eca484cd692aa7f967e718190a52ebbf9e9e6a5bfb9e7e26555dcd8de2f5aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b4b6a03c9d98359fec6f66f7a28d7621a63550567e80b517d0ab41808568577"
    sha256 cellar: :any_skip_relocation, catalina:      "28cc004f8bfcb8bc100cf3a4974d58c18fab019fa6a4665aab4338d914700ecb"
    sha256 cellar: :any_skip_relocation, mojave:        "e651eaa0c5791d732d81880034fbf117fb585334c3a6371625bbdcc89d274c24"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "podman-remote-darwin"
    bin.install "bin/podman-remote-darwin" => "podman"

    system "make", "install-podman-remote-darwin-docs"
    man1.install Dir["docs/build/remote/darwin/*.1"]

    bash_completion.install "completions/bash/podman"
    zsh_completion.install "completions/zsh/_podman"
  end

  test do
    assert_match "podman version #{version}", shell_output("#{bin}/podman -v")
    assert_match(/Error: Cannot connect to the Podman socket/i, shell_output("#{bin}/podman info 2>&1", 125))
  end
end
