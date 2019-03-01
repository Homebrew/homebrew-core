class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.11.1.tar.gz"
  sha256 "f597786245787eb1e178e2d4131fa229520574d8f959c0cabfd497f3c6b9fede"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbe1b0303c3857425ee29432625181b573ff189a77f59299d84cee06829e89c3" => :mojave
    sha256 "e481aaa7fe9c75394df849b5b0bc34f65b645d3f033743f540a038962b3db1a6" => :high_sierra
    sha256 "7ddf5a9bedd25855eae1479ca9a37566e277604a39f49156b8d3e2f92388162f" => :sierra
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
