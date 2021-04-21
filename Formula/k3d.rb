class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.4.2.tar.gz"
  sha256 "e3e6bc85b7f548580023671f59cec18c4c7f99ad3c7c37d1838984f82d4bf86c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "140eb9a2e7cc9effa9454b90635f2da96b9c1d7c7ccebbc150f60849376d80bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "c177334372abe0bbfacde70bc45a22cee74c4ee916c41ce0bbcbb9eca73b7a08"
    sha256 cellar: :any_skip_relocation, catalina:      "6d0176e00e99a71db1f9a09982f886c768ae13d1bf595e9d0bf4e8b015677fbb"
    sha256 cellar: :any_skip_relocation, mojave:        "76d106d7ad491c72fa34994be2a87678758c3d35e37fe960ee30486f310c0a94"
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
