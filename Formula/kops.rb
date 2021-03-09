class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.19.1.tar.gz"
  sha256 "c7b1c362712d75119e25e4ec06dc44ddc810808c0ae3ed24fb1ca47ebc2d6b7b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "8eae3a6b5c102d8a8f48eff9c8cb4dad2aaef4b25188b22762b891efdf0f1b06"
    sha256 cellar: :any_skip_relocation, catalina: "7293594cd3dd96b7dfa4a1ab47f36ed9783f1d7691a53d03e0a9fb3afbdd64a8"
    sha256 cellar: :any_skip_relocation, mojave:   "c7d69ce9e59abd04088c227b738b668ef12c240656ec3bd369dd38263b4c228d"
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
