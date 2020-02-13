class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.21.tar.gz"
  sha256 "14d976c39f7faa80eb249668982cbf40dd5d6f3edf9879cd3d8ffa604121353f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d7d73b32f30915021fc89e6f61a480d82c1c7ebc956b27fe596e0b53ca33c8c" => :catalina
    sha256 "7811c9d20dadee9114ae8661dc222198532776e1bc15cbef3a2b9e6e7b225ec0" => :mojave
    sha256 "68dec969ac43db5db54a05657142e9375b26b595e5e7b3810b85b8da49f5f03e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
