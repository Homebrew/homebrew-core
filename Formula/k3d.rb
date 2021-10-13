class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v5.0.1.tar.gz"
  sha256 "2b33c3daa69427b7e795914ff617365f271746b688ca0cb70ed5f905df09eee2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ba791a3644f2ce7168ccd322199bd6cc4837342abc624b2e432904382270bcd"
    sha256 cellar: :any_skip_relocation, big_sur:       "3edc7b27c97d31dcd2dd7c9a34fd8fa7b82a844877e1139505fe19339fa79b09"
    sha256 cellar: :any_skip_relocation, catalina:      "c016ae482f227f8a6d4bf2809acd43b2e255eff3bee67d103399cdb31630ee72"
    sha256 cellar: :any_skip_relocation, mojave:        "b55a20b2b9b39fbdfefde8ad58470e9f9c8f1a109c3f986ec4caccd7afa65940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a8adf3ae97e070632f06c7f7449a73302bc8fe459e4a41f2f2a51d8a31fbe6"
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
