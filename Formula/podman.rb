class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman/archive/v3.1.0.tar.gz"
  sha256 "60031aa620cbfab641ffef9cb4e68240a0383c23ffd0276938684e98794bb5db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4279909c359a239c506343680999e40c857c60548d16de5d39a858f4da7694c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7da38abe38c40d73ee1353bff35a3eb48f61b5b30b9f4895ce110882811969f"
    sha256 cellar: :any_skip_relocation, catalina:      "ca2359c8e5302c337c1396fcc8f46e620727313f56cf3895c5fe1c6b7f2fd566"
    sha256 cellar: :any_skip_relocation, mojave:        "00277977f10e892ad1f22cf01af746a6075ef2032134dd68accdde4ed133ca75"
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
