class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.2.1.tar.gz"
  sha256 "140cbe8d6cb7807cbd3ef6d549d888e1c0e44d32dcff3a27453630fc52e7f5b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b72a56e67472d87c4ff2ad3069185f0c91ec753983a4f898e0629556548aec0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a9ca5d9bc4ba5ef5b854ddf70ebff1d483e9ec1e2009f8cc8490879cdfca004"
    sha256 cellar: :any_skip_relocation, catalina:      "99afd9a5db54007374470d775143b49a040ca6f44ace395c510b4eadad880586"
    sha256 cellar: :any_skip_relocation, mojave:        "472fa9fe5baf06b72ff359a411a5fb86ba2184f0afdb13593e1e76b4c247653c"
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
