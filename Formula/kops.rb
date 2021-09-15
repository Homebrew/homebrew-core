class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.21.1.tar.gz"
  sha256 "4b1f5dcc5bc8909a7f68698c356144dc63264c4af723aecfa18a0e31ed521009"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab18ed01fa59ff645ea08f83b36ac0e5fcdb5a59a8ccea1d845d674193d8f1d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "df0f4405b78b6b34277d6543d0e86aa47af07c5b0b58418a3388577c9d5b280e"
    sha256 cellar: :any_skip_relocation, catalina:      "4282f738df8fc2bfcc92c4c273063372d92a1060e47896fb9141dea6c2dd580d"
    sha256 cellar: :any_skip_relocation, mojave:        "01a39ba6440881bb7513b6b332f8f89f2861f3ff252e460c00c596b24571a2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1642575ac0a6191f5bc75c7580729bc971e4f77a20db16680e62487e1c6755f6"
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
