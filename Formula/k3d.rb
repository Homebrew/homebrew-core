class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v3.0.0.tar.gz"
  sha256 "939fae09600ae7edb5e92ecab5c25ac2adec5be432c8a7ee34a14e01a0245b11"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1363893ef0fefaa579ea21f1dd546d2d88b44316e2df7746e31a0732aa1beb81" => :catalina
    sha256 "51e0a32d8d8ddba6386c5243e3a3a22a730020769d30962e2778c586da8088da" => :mojave
    sha256 "2958a2c668ebe0d064610e680898e895ede437775b2f7fa225a30ee5c9aa3ae5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/v3/version.Version=v#{version}"\
           " -X github.com/rancher/k3d/v3/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output

    prefix.install_metafiles
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
