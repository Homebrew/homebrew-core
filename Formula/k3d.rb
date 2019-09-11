class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.1.tar.gz"
  sha256 "5f421f933191e1ee997131235118a2d0873a04053d47e52583cd17a573f89b82"

  bottle do
    cellar :any_skip_relocation
    sha256 "30fcc787ad41c78c5606d5185fba3ad1979a5076d9fd85d54a859debf60cfaee" => :mojave
    sha256 "1f6c377984fdec8bf606cf7de8040ad6671129cf56ec0e56bbe69018c8758ea5" => :high_sierra
    sha256 "23b4221d5679847b4cc93639eae5d2473325ca2a0bce1f82ae498ab11a552786" => :sierra
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
