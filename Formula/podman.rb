class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.0.tar.gz"
  sha256 "1206377b12c11d4065bc4789fa104ca139ba77bb5b33541f07e8e95ae4d2932a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "052765ca9ade7d0c84a448cce179da9c08e4bee8395162205cfdb9732da39f06"
    sha256 cellar: :any_skip_relocation, big_sur:       "1762fa3d1f020a3d05ffc7d602f90b44e3afcd2e0dd4fee26e71875189d88b3a"
    sha256 cellar: :any_skip_relocation, catalina:      "8539d15055a39014122fd4ebd4e400ffb8772a4e4d8bd8d86b71835a7707e19d"
    sha256 cellar: :any_skip_relocation, mojave:        "2dd6056c5154ff860807df812de4b703d0f63b7e3ab8dc1b87379c5d1742a524"
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
