class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.15.1.tar.gz"
  sha256 "4446092e7717e9735e18eea5c8de552db7023a4bd4d035cc1c4229b4d16f44b3"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a530389340d0b3856313d046fab3e67ce069e2f2c25de53165dec4e837a2338e" => :catalina
    sha256 "04fa19e30a1dee4d2c76b59d5c6b3742d80a91aefbd7bf5e3a3500ed4aef93bc" => :mojave
    sha256 "d0666740633a7f210e78143e0c89146c9374cf202a57335c1569092f2b6db8ea" => :high_sierra
  end

  depends_on "go@1.12" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
