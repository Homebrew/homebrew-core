class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.0.tar.gz"
  sha256 "a4badf58c2d815f35543e341f240ac028b2cb5c7ea7a4a565dbae69481ceec99"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cb6351f986a888369f1f9cadb2975f39d0ff4fb12cd030348c0b11be4f169d8" => :mojave
    sha256 "bbd9694917f964b6c860cfaa0e24f33f315375022bc0a6518b63fd0b93dfb7b9" => :high_sierra
    sha256 "9aa08d161d10a5e08968af8cdcea860e0ac572669e73cb8b797ee343f2351ef9" => :sierra
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
