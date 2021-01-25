class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.18.2.tar.gz"
  sha256 "7f2614cfca0a8a71b187f276460e17c2487b1fb11cb389ba4adbe69e8ca9f88f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1e89ba83e73773e0884f64f98d87b3f77fc54817ad5819297d21f82ee2aeb391" => :big_sur
    sha256 "0709f842c5b427efb976d73d845577c415bf0c0753f84f6b3117aed903a51664" => :catalina
    sha256 "3f9dbd8e1db1f118a4aebe4e1c827e2cdce804d196f67838ef02da307ccb1545" => :mojave
    sha256 "114fe9e812d319e8a50046255936230a2de7b07503432271c115d54171b695d5" => :high_sierra
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
