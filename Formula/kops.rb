class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.11.0.tar.gz"
  sha256 "1517abdda57a1f6ad1cb6dcab2b2c23ff15618006ed3bd6724096d13e942d8fb"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1349e0849f72dc4a3fdf9908fb9e5c3bac273d36d16a2fe185feedd95abb448" => :mojave
    sha256 "f846c1106d7bb9b12e9887a3715633158555f1bce6a58ab88f99fb6f2d6f419b" => :high_sierra
    sha256 "83dd443876381d47f70d5f94c1e928ebce18f0d1a07d8b90331396f4b13778c1" => :sierra
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
