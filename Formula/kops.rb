class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.10.1.tar.gz"
  sha256 "9f0a0f078841ffa8b2f0192aa0eea38c1aefb9cff5d72d2a4e6d8265a75f215c"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdfbcb1dd38b71a8dd1f20e5b2155a56b7eda71bef72a98216356859332084eb" => :mojave
    sha256 "8869572a3af21c8d08588b3605e5e0d63c02f18d5e39cc00578e94b39b0e484d" => :high_sierra
    sha256 "9f41f7d73ba4c340ead714cadb882e793b39bcb807c4b67b801e685a1595d4fc" => :sierra
    sha256 "c52f609532178a621b4da9f83801e4168377d2860070a7aa2e7dbffaebe7c6a3" => :el_capitan
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
