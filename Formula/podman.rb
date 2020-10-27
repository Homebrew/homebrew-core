class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v2.1.1.tar.gz"
  sha256 "5ebaa6e0dbd7fd1863f70d2bc71dc8a94e195c3339c17e3cac4560c9ec5747f8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb411460ee3d91f8286df3eadd4dfd0fec63d61e29a8a6c29c581ac073642011" => :catalina
    sha256 "09967354204cdd075332de1ba2eaf39ae154da5167200ead9e2db38d96f7a96b" => :mojave
    sha256 "fb2ca2c9370177bddf1f1683cef3d121fbdb72126a3999eddc097f20ec637540" => :high_sierra
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
    assert_match "Error: Get", shell_output("#{bin}/podman info 2>&1", 125)
  end
end
