class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.5.tar.gz"
  sha256 "83bb5bba1db48d26c5344ddfd046d86dcc90c5c5700015918adefe21b4d0275a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b07b0034c923b8a79d981facc2568562bb97c6095140c0cf4e7157476faae9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b18fc787ae363c081ae88e6a11fe0f1d8dedf1e704bf2182ae84cf4fb7dd3803"
    sha256 cellar: :any_skip_relocation, catalina:      "b9c0f0fdcde9d98bebb1a636ec886f08998305e5ba8cebe672b7886f9baf5ef3"
    sha256 cellar: :any_skip_relocation, mojave:        "7b09ef709b2b39ac1208ff42bfd2a435e1ec0a0e43960fd1887fff84a0ed1866"
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
