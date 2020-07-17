class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v3.0.0.tar.gz"
  sha256 "939fae09600ae7edb5e92ecab5c25ac2adec5be432c8a7ee34a14e01a0245b11"
  license "MIT"

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
           "-ldflags", "-s -w -X github.com/rancher/k3d/v3/version.Version=v#{version}",
           "-trimpath", "-o", bin/"k3d"
    prefix.install_metafiles
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d --version")
  end
end
