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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6f75f344b5bfa38ff54125b3e46a16aca526d70ecb81858be94b90706582208"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcab23a9556ff0de9ec455854d11ec14fe5f888d2cb9d8ceeb4a75a12ddc4281"
    sha256 cellar: :any_skip_relocation, catalina:      "3dd1c755bd7384305ba0fddc1fad921bb418d209149961bc4b891d00c8570e86"
    sha256 cellar: :any_skip_relocation, mojave:        "033edc03203c95141063b284dd757b15e13971ef482249b7bba702d34428fc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071abf3a8ea3ebc1840fefa5ebc3c373aacb23931c38010672b5914345ac5ba7"
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
