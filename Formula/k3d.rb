class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.2.2.tar.gz"
  sha256 "ad6f0dea13e6e67e3d039a9d19d7fc62affb2397d7de73b2af5283c1263eb68e"

  bottle do
    cellar :any_skip_relocation
    sha256 "620c5c48136893d5dd803348ff92e0521f20ed9a26931426fe95e326bd52fc23" => :mojave
    sha256 "85f62c31e1cb766e013db1a76ddd4648b1ceab4ee3bb74c162efe374a600c9e7" => :high_sierra
    sha256 "35398249b03ec689247d286141daa1abda05eab4bcb6d39456fc5604435cff30" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "BINDIR='#{bin}'", "GIT_TAG='#{version}'", "build"
  end

  test do
    system "#{bin}/k3d", "-v"
    assert_match "Checking docker...",
                 shell_output("#{bin}/k3d ct 2>&1", 1)
  end
end
