class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v5.1.0.tar.gz"
  sha256 "d34b047c6b2bd215deeeb52c3d4ba4c069e6edb15e5c132c7a3cbef24a8a183e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd693e2a4c67650ab61a376c552aff9f192dfb9727a49528cb3381a54342e053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdce7075b10bef41b495a75a22271c0a14cc8fbda1af4da24d668ea9c08fd909"
    sha256 cellar: :any_skip_relocation, monterey:       "fd0e600ee8dfce0794a430a5019cbeaa9ea6aea374ff1fa55135a8e555341c56"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da258f17681cd21d16a5c06af593b5d7f3f447d532b0957ff7481993f5e5182"
    sha256 cellar: :any_skip_relocation, catalina:       "84869a0ca57bf4c0f690e7155e694177900aa1ef0371add5bc8e0b04d1874ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "672e70309bcb98f0c01d21a3d2613792581cdb7dc607114dc4c6b76df94cae75"
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
