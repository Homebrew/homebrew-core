class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v3.1.3.tar.gz"
  sha256 "47e3388cb7960253af625550462f47867936b07625a0318eccde2551048eb5a2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "88ab5b832c60780a77a5ab23fb9279e7aa8fffb54f9c372e835cbfb335961b9c" => :catalina
    sha256 "469179e733517139915d369b4deb1587291ee4f1e635d86a47ef8aeae7b84372" => :mojave
    sha256 "243b148634fa7f0e756fbac37a9ade3e380ceee3806479cf1a9883ce9ee14f95" => :high_sierra
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
