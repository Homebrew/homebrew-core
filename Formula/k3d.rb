class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v3.1.1.tar.gz"
  sha256 "d7ccf6057a1915397c36a6cba72014f8c2b9b15433269649368af49cf086bf13"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ca86df233277297e25fb4804ee6a1f506d72e8eb11c7ed6cc581a0d7b6319205" => :catalina
    sha256 "6231d2ec93f2b6265bd83f144750e1fc9f2e93c9aaa6c99417881f97fd5f475d" => :mojave
    sha256 "528a198e400f2a86f5b39a6f29baa07b9d8a102438313a65cb7d0419b6c55f69" => :high_sierra
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
    assert_match output,
      "\x1B\[31mFATA\x1B\[0m\[0000\]\ No\ nodes\ found\ for\ cluster\ '6d6de430dbd8080d690758a4b5d57c86'\ "
  end
end
