class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.16.0.tar.gz"
  sha256 "0154395acb7d612a3f072e29db424d8c8065d77b324540a1517aab297d28b3ff"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dce4603ff54c4adff317a8a05f60feb23e87e8d46d26cf0b4256bf5b6c790c50" => :catalina
    sha256 "fd79da68b689dc874c7811a4ed4f7b0ee98b85c634cafb8746f70f3b0ef4aaba" => :mojave
    sha256 "8c682d4e0fc93cb03fd13d1638f2654e94f9a2f1654cd0a032a33cc1f56d4818" => :high_sierra
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
