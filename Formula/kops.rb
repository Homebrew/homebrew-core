class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.0.tar.gz"
  sha256 "ac5b8662fa109c96b22436417fa1654ebb94fddfdf0568813acb41226962052c"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "245571005ee67785ddb5b5daf3b5e165bdc41b75a8db623d80bba156e56f9735"
    sha256 cellar: :any_skip_relocation, big_sur:       "e879db425fa25e33df281fe902cece8f0049fcb7690a38e90ae4c32343c11121"
    sha256 cellar: :any_skip_relocation, catalina:      "7923d7b4c454def5265e7e83cd7b9ba8db72ba18447ceabf871e43034282b1e5"
    sha256 cellar: :any_skip_relocation, mojave:        "1cc28c8cf60517fe8304fdba0c8a3ca6d8477c8363690e7bcc6d8b4075204da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a78e6c6a0363359e9f1614dbf3bac2dbfd194f0baac744b1f4e4f187a3c5e78"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
