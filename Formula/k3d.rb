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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf68055b20d63a9aa8e091685e5bf010e196487cb1cba5a7cc65cccde7d93895"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff1aeeb92093124d94da03ff95560824af23a9fd88597dc82a6b4acac0e1e2da"
    sha256 cellar: :any_skip_relocation, catalina:      "2db8ca70c3523c88dd102a680e2dd34151a4a0bd34279b14e96b861cbdd3f4f8"
    sha256 cellar: :any_skip_relocation, mojave:        "4074e46dc698e50dbdf90750b76dab00d95bb6d795e611a1ff7c0a941c36e258"
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
