class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.12.1.tar.gz"
  sha256 "0ea72a28fedfc2ed6b2bcda4ad02d4fc9d4548c47b9011c4526da95f8b7a3d71"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d120fb1e2d416c3efd3732d70efa355d2769b256594572290228d50895fdfa3e" => :mojave
    sha256 "107548437944143df247ef0d8c1bca5036cbe8de51623929b6d64083cf93e706" => :high_sierra
    sha256 "9a33ccdf3a45873fb153497ab05468d91d3c785124a9b0015987af73216b3ed6" => :sierra
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
