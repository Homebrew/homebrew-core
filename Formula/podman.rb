class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.1.2.tar.gz"
  sha256 "5a0d42e03d15e32c5c54a147da5ef1b8928ec00982ac9e3f1edc82c5e614b6d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "086c794c206561e2e2ab2c7431f214ad928953e3f3bb5657463464af09c26380"
    sha256 cellar: :any_skip_relocation, big_sur:       "be8796688151a6157de4c67dc9ec92d96c67605cd898819dc2185d81b7412031"
    sha256 cellar: :any_skip_relocation, catalina:      "663484ca9fc2591b3c7787a70c2bef55906a8ddcae651950da5368bed4a21b3e"
    sha256 cellar: :any_skip_relocation, mojave:        "e87d35f19391e7921773bf64608bd35d3da3d2a127b4424690a469964c2235d9"
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
