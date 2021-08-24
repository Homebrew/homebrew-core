class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.21.1.tar.gz"
  sha256 "4b1f5dcc5bc8909a7f68698c356144dc63264c4af723aecfa18a0e31ed521009"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7741e7c13fce8e0e46defc2ede4d65d19a668ca42afa298b90247d9649d081f"
    sha256 cellar: :any_skip_relocation, big_sur:       "23dec5163db7d299b12ab1ee3ec993ffa7bca1065ed4579d79e787332def6190"
    sha256 cellar: :any_skip_relocation, catalina:      "53b6da54ecb3c4ec63296bed6f29359de2fcc60c193312a3b12c07dd046fbfab"
    sha256 cellar: :any_skip_relocation, mojave:        "85a9c1af389f0bf9255dba02e2be8a35bbd8bab371f693bbae3bd1bf1b574f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6152d695842c1098c952d8346e851a1b0774d783c7f1b53b7661915467fb50"
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
