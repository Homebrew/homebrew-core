class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.4.0.tar.gz"
  sha256 "849942d0bc01318aae08bd6e56eaac8d738076065fb3d8e3f53bc2c024437e18"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "924f1b505a80875275bf7444c656e5179cefd3d4d6695062686288b6b3cb79d0" => :catalina
    sha256 "accbdaaeb582efc36e80a16bbe84a273c49e793549de52a71114d587957c4d25" => :mojave
    sha256 "6b4728e2db86221cd26f8825b5729e9bffaf86ce0a71619089b766ff02e69159" => :high_sierra
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
