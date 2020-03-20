class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.7.0.tar.gz"
  sha256 "e741809eb27f707c0f22c19a41ebbd6be7c20ec275285bb12bbf437a675aafb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fdae48eb6bf17c5d275fd79068841576be31805312eec204b7735ba59944a39" => :catalina
    sha256 "bc404ca65e1d7c4ad19d099911e89793544ff7c9057756036897eeb515e0c443" => :mojave
    sha256 "efe0766f90d50ee30dac8455b1a6e4bd37818917b794ec184df80d05f936847b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/version.Version=v#{version} " \
                       "-X github.com/rancher/k3d/version.K3sVersion=v1.0.1",
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
