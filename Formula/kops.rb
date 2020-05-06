class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.2.tar.gz"
  sha256 "1eb665522e302e8025ea8abc9f9e62d04c3e0518e406ab013100d2364b92c94e"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c96317ae5c02d9ee0ab9d5cdee2840b5ca29afda6c18057fd2e14f8e83f6b473" => :catalina
    sha256 "c6d2f859e2d281841d717f7bbd427e2d3a8ef8041ac2526a57d0e31173c2911e" => :mojave
    sha256 "408c673eb3d4bb1ac1c845072212011f3c9af84a03456e18f5582e225503e30c" => :high_sierra
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
