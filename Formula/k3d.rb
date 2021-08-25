class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.8.tar.gz"
  sha256 "d576441faa0b3ec140e5dc3a3f5b2dd8018ddb9b39bc2f19a58a2e66d8e4e074"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0a8c2a561c496916eebc943e3c68ff25795c55782b2077e42a70215146626ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ef92951dee11c02ac78c313f98bd39159cfc85c96ccfc7a71837821a11cf0d"
    sha256 cellar: :any_skip_relocation, catalina:      "0327dd00710fa18934e14cc143a0c367081107155da26facc1b8bf33b203ae30"
    sha256 cellar: :any_skip_relocation, mojave:        "951dddec084d22bcfbdd534e9bc1b64c90ab3f32ccfd201b77503af29d4b8022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7850a4084645cdd45892045e76b26284f9e8bf98e2d16fc96a7faae0b412d5ae"
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

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "fish")
    (fish_completion/"k3d.fish").write output
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
