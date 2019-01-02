class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.11.0.tar.gz"
  sha256 "1517abdda57a1f6ad1cb6dcab2b2c23ff15618006ed3bd6724096d13e942d8fb"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e55b4217e7d15f9e308f8ac92530292e74643bc95ed0486e9a8712ec5368765b" => :mojave
    sha256 "b3da27b920255d98104637734aa5328a66952f5e32f09b5f0496ffdbecca0952" => :high_sierra
    sha256 "5631e7adf5b071295e347701db73ebe97e1baba9e157264ac06d462e4d2cc937" => :sierra
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
