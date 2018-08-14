class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.4.tar.gz"
  sha256 "b3e8cdae1164928480b6221b87e7dd02ba32f8427efd442e5ffb81d493510d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6df3c61a2e3d6345f5d219e0153be0c2bddea141101aa20cfb5649851a82c08" => :high_sierra
    sha256 "7584a5da68b9f3be6febf6e88c3353fc51a9d3d7d3ced74da1a8609cf2fd224d" => :sierra
    sha256 "49e32a3821d790f65ee7017ad40e0fa1a6a84af56f509d0e86cc17051c2a754d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
