class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.1.tar.gz"
  sha256 "8dac74188a4043f06d2dd6ea5123a5ce3ad32fcb8efb6256eaabc7fa2cb1af09"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bb30885f070d1f9c5777f1a227d62842f54c19ff754e99a54b12f0e3453d342"
    sha256 cellar: :any_skip_relocation, big_sur:       "63d23da4a4b32ec8071bcade9c21a001178790ea72f0ea4cc1e6686ae8b87890"
    sha256 cellar: :any_skip_relocation, catalina:      "a362920eb9baaa0aa8bbdcf51e5fa5ede8343482a072f2a77ebe104d37ea739d"
    sha256 cellar: :any_skip_relocation, mojave:        "0e6fb24acae071d996bd5070c7ac362988b20cd80ab08689565d4ab638ee31ed"
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
