class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.0.0.tar.gz"
  sha256 "4e9e81f570de200bbe42f452cda5366e24e35d94c303b6cc5052370552a925e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33eeabfd1f3531ed132453326921e7fd3a7aa4777e7be6f9700084e0154c8b71"
    sha256 cellar: :any_skip_relocation, big_sur:       "62e5db4310e5beda29e57cf9938da983717486d550b230f8a7bf524b2a7c24ba"
    sha256 cellar: :any_skip_relocation, catalina:      "98dc5c2e5c0b9481769a381228c55a0528fe4be965fc2ad0719120fda970c459"
    sha256 cellar: :any_skip_relocation, mojave:        "fee88938d4410fcbd4d0e94f6892be61bcda243564b29814090d93736cb6db15"
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
    assert_match "Error: Cannot connect to the Podman socket", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
