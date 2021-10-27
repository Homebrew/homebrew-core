class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.1.tar.gz"
  sha256 "47c9eae2bb12073cab907c2ffbe10bf54141f2ce6637291de7faffc9241b5b85"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4afe9602992c299ec9b1f669db3b531ad759ba9ace95af75dbb1d0e37a35e882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ee7828fed2bd73943b205df66999cf07c7ee3d4336f64c8f7f8eec783813130"
    sha256 cellar: :any_skip_relocation, monterey:       "7f24cfcb67ee089498ca7c468ff50d4e5a93f6cdc2e1efacbae6f669f09ba0f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "76f3897d3cc73a98334294c4f281f09e7a62e66bf41e814f8ba0657fa7d79756"
    sha256 cellar: :any_skip_relocation, catalina:       "75e1cbda813e2001fc128f071ea51a23a0aa263f87001b2ed613a2a2c30493e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "570ba96bc239787319e07f49f5f3732354f5ec5198482dca7d85e4d38a9bc998"
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
