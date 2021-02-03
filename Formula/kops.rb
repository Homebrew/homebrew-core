class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.19.0.tar.gz"
  sha256 "5cd8b8ab1e0412c9bb3a40d166653d8f447448c62478e029fe2d68b593e4c6dd"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "5017210f634c7f79b8dcde2f02cf16c19ecaba26285540f462381c440be55b8e"
    sha256 cellar: :any_skip_relocation, catalina: "aadacf2463229576790c7035cb231d6f78661c744cfdba1667305c556efd58e4"
    sha256 cellar: :any_skip_relocation, mojave:   "ef46f1bd7cee14ee1f81d17c2f49de6871a4f14dd428ea47d06bd65a72fdd384"
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
