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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd7c8e4270996845164dfcbbd58995c6536160cb94cc107af533fcc2d463115b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94b60e00ef99c93f8a684dd9de14c6188e301e471113f3156c8ab621270d911"
    sha256 cellar: :any_skip_relocation, monterey:       "8301adcc1ee53135b47891713adee35131b83cf466f2ce5c21814d085ac5e231"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1d150c6cf260a17b16a155d305f20a97a80e6d7ae5e35671db8dc4a26c4885e"
    sha256 cellar: :any_skip_relocation, catalina:       "d7777725eba873299f2344508b907d833973744640973a1201b053a18388d1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e117dd2b6ebf56a0def38e790920f5c9ac9bbdbfe1abb617c933f46db8770f40"
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
