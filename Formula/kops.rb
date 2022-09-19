class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.25.0.tar.gz"
  sha256 "a75d7971ee52eed5167c8eee085a02740dc73526d01fd56d3e8bb849c53b1861"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d21dab233599eab14674791b3c10a331bff90948aae459dd8f1d30e434073f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5acc32b5f66a288d22357bfd80db67348ada0ccc6c28dfd191ad1195d29b26e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d75390a267428a756c21e794dc279f820a8d51f0778b3747ff995b3e4e91b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "db3b40e2c55a8ccd3326b2aaf3767f24dd79f8db7cb6d20b92f09f8e1a1497ac"
    sha256 cellar: :any_skip_relocation, catalina:       "47a27b2e5dd9d540bff8bedbb2b39335f2353e68f5f1c0eba806e3245484021c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3650a9ae6071965c45b47376529e2ddacd0f78a81e61ebe3480ae4e9528a222"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
