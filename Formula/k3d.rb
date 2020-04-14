class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.7.0.tar.gz"
  sha256 "e741809eb27f707c0f22c19a41ebbd6be7c20ec275285bb12bbf437a675aafb7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ad3eae311a48f86e63d4e058c8f9c99304d16f831e4bdb54f3dc21c3341863da" => :catalina
    sha256 "d1a7179fc1131f32ab2715d1263587fcff17515f63c3b677f10422d4dc6a6de4" => :mojave
    sha256 "c4d632801264948010813712a907061f26782f09f91f01e2cf0f92633e129b05" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/version.Version=v#{version}",
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
