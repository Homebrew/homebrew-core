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
    sha256 "aa71e0cc7ac2a06c6755f71e9220137fef5a34053ecd45cb16696ce7a7f4e6a9" => :catalina
    sha256 "316cbe047504ba40097fdefe1486b6eda6b040c650b0cdd405cccc8b20be265a" => :mojave
    sha256 "9fe9f6c3c03551f0c4aa7acb5b89df1cd28779de6de4baa058a2fae8b41b45ce" => :high_sierra
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
