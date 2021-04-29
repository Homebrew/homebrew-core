class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.3.tar.gz"
  sha256 "b7ff3d5fac9d0bc6c58c3e5abdb5b2f38bf63a7a6bf0c3872e64f63879f4c160"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da574c2a76ff675e655b9b5ab13da7819ef0ade675ad18dde491c940dee03fac"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3f08b90642e2307fb93c17b6fb5f25523e3807c3d092c37d26dd48440d2456e"
    sha256 cellar: :any_skip_relocation, catalina:      "e9f0bdd09cec50ccc95f79f2759782bf5425226098ac60c7145f7b78d3ab4bbd"
    sha256 cellar: :any_skip_relocation, mojave:        "3c010c7bc9c3e825147b949962468b65722829e442b661c6a95a0072a99981dc"
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
