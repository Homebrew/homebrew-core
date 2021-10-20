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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a81a3d44602080905d164788d5dd54aaa6b5d1ea7b54ecde224a15704ffad579"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c19049b247166ec76425f24b2430e0c2a88f4a3a80c0cc4d4fa17b529ab4abd"
    sha256 cellar: :any_skip_relocation, catalina:      "7ed5bab062d3107ff2019812c44bb0068fec5fb7deb80ad2272adb6106f9dc22"
    sha256 cellar: :any_skip_relocation, mojave:        "935f2464da6c3c66a0f7f3604d53b6a733c9075e3afab13ff0b78cfdb09b812a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881b47421254092c0246edd293071692eccfd873a1660e73d7a08b7f965406bb"
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
