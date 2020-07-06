class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.7.0.tar.gz"
  sha256 "e741809eb27f707c0f22c19a41ebbd6be7c20ec275285bb12bbf437a675aafb7"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3c1dd20b30c4a51347c2c01a5dc4346e4aa4ffc9162cb9f187df43d333192c28" => :catalina
    sha256 "0039236f61e40518ebfc684b45a5f13aa3ac9c6da15128b7a67fb020961e1605" => :mojave
    sha256 "3e63ce46a496a7fe264aa10583115f4fa5e51eaa04020ffbe1c73962fe55b755" => :high_sierra
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
