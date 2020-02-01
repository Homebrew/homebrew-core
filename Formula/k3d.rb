class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.6.0.tar.gz"
  sha256 "a6c6b9680e2026cdbcaf78ce97269994c0b117c4e2515e89129aecb67334a0e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "a14ddacb632ef51d599074cc5d2fa018d534c3ae9dc1d783e5a89ec13eb421b9" => :catalina
    sha256 "033c991d2715bca8b628e5c8974834239f85c1247c1091d18b6970a743cfacb3" => :mojave
    sha256 "140442572cbfaeb415a29523b801b84b9721e631b5f72d9aa74250b93cb07ba7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", \
        "-mod", "vendor", \
        "-ldflags", "-s -w -X github.com/rancher/k3d/version.Version=v#{version} -X github.com/rancher/k3d/version.K3sVersion=v1.0.1", \
        "-trimpath", "-o", bin/"k3d"
    prefix.install_metafiles
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d --version")
    code = if File.exist?("/var/run/docker.sock")
      0
    else
      1
    end
    assert_match "Checking docker...", shell_output("#{bin}/k3d check-tools 2>&1", code)
  end
end
