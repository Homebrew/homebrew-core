class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v3.2.1.tar.gz"
  sha256 "03507f9a708e6c98f3cf994742d193896c5f907940b9593bf85a10101e296977"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7816cbabf4c1117b6bde378b273bc8e19207ccddc968046082394fa1e894b83" => :catalina
    sha256 "bad5b1c426acf2bf73d822bc2906450f720457f03c0c8581460b5107dcddb3c4" => :mojave
    sha256 "e72b412df021f3f2155ecc0dbab42b612ce4c53258178fa87383834589cfccdd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/v#{version.major}/version.Version=v#{version}"\
           " -X github.com/rancher/k3d/v#{version.major}/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output
  end

  test do
    assert_match "k3d version v#{version}\nk3s version latest (default)", shell_output("#{bin}/k3d --version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
