class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.20.2.tar.gz"
  sha256 "1d3548e003cafe664b6721bf3b06a6139d4e283b3726281cae15d072311d4b5e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee460c56c2a6cf62dc73182ee03751c2b0f636739dc9580a65ae9c6f01d5dfac"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc76ef80405215e3d2a7fe3ec3a6590e215286ca4ede2c6a23a6c403f49bbe43"
    sha256 cellar: :any_skip_relocation, catalina:      "e84992b3fcc269ab97967f8d7dc8611e1a639f2430fe782e8db65ef99347362e"
    sha256 cellar: :any_skip_relocation, mojave:        "af7138ea9bba23e0ca24121d16c105a288d6eb65bf90a753829cd35ef7e8d865"
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
