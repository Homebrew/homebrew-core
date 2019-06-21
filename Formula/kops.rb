class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.12.2.tar.gz"
  sha256 "e453bfd39a8bd079a14cf8d8c1b22d1429ccd4f5701b55f3612528263aeb97e6"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8edc1b5c421fc18a911db6210e2e7c34158c3c9ebb7b5e6afd06acfd3325e78" => :mojave
    sha256 "93ec062792caac6be68f00605d9dcecf69a824dd2bca89ff2eda85d8cd54a186" => :high_sierra
    sha256 "57e12bf567e1340d0f8fd82fd025479ebc3d6527215252cd42eedf164ec11e2b" => :sierra
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
