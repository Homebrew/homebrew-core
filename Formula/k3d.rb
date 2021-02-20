class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.2.0.tar.gz"
  sha256 "4dd135611c27992b3c93128be638a4fc27d5153b1b554ed9eaf0eb20b2d67d2e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72ffcbe9e312396177d2a972b58792b278c2008197c4a83597a382dc192a73e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5078ce5f2a29156907c573544266c8af47fb85e3a6391136364b16f29c79e475"
    sha256 cellar: :any_skip_relocation, catalina:      "681d8a3512601fb6ea82e391c19a7efd2a84a24449a8045237a444eb0ccdc670"
    sha256 cellar: :any_skip_relocation, mojave:        "0e2d81ce69d5d8bed36bfa3753f11be404297db46f11a4cfaf95a048958047ed"
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
