class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.0.tar.gz"
  sha256 "1206377b12c11d4065bc4789fa104ca139ba77bb5b33541f07e8e95ae4d2932a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad691bceb01eb6b5feaa63ec3ff66cd4419917c9178e26306c0665c98c6a4158"
    sha256 cellar: :any_skip_relocation, big_sur:       "56504f52fd7058f94899a0ca8ada9428d938cf23995c22caa6e6402b5748d370"
    sha256 cellar: :any_skip_relocation, catalina:      "5b3c96150a41fb91855739a88230111fe1244ac3e6a65118321c7847dd3a8faf"
    sha256 cellar: :any_skip_relocation, mojave:        "392bd1082d895878d5ff3b2ba6d399767e01021659524ca752538271a09b6dc8"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

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
  end
end
