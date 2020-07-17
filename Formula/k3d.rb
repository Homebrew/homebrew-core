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
           "-ldflags", "-s -w -X github.com/rancher/k3d/v3/version.Version=v#{version}"\
           " -X github.com/rancher/k3d/v3/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"
    prefix.install_metafiles
  end

  test do
    assert_match "k3d version v#{version}\nk3s version latest (default)", shell_output("#{bin}/k3d --version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match output,
      "\x1B\[31mFATA\x1B\[0m\[0000\]\ No\ nodes\ found\ for\ cluster\ '6d6de430dbd8080d690758a4b5d57c86'\ "
  end
end
