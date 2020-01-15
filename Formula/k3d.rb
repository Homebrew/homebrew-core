class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.4.0.tar.gz"
  sha256 "849942d0bc01318aae08bd6e56eaac8d738076065fb3d8e3f53bc2c024437e18"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b842404ac3408dcf542b300f8bce83c563bd28ae4e784af1922237d1629934a" => :catalina
    sha256 "31bbbe046f861fa7b392fb56b1f3264b05129d1384b7c18241b8327946dd46ae" => :mojave
    sha256 "923ba1112c13a27169a37d17ab03929ae9ff8fe7b5299cd9c13b5735a70a8423" => :high_sierra
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
