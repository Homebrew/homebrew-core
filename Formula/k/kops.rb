class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.28.4.tar.gz"
  sha256 "755ffbb74f7f0157c18ef16a81f44b170db780ac7ef371e497ebaa6be235440c"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d1f8c44b8485e1b6621cc70371f82cf7a99f6dc4262175bd06c425488e8b7ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ee82b769536795024f89058b76ab757faa5d3b61c90b31e3c4d10aac4ca199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d6bcd2afb420b1f20a99757e1a1be96e8b4df9322a68818386098edb4bd4a68"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad9b11fb3e49fda3de48495ac2d212ec02b40f25b8ace3e75453bce43aebc200"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd4394e55f5bae93b1194775d728989e8d78156384495256fde1948f4fd1f79"
    sha256 cellar: :any_skip_relocation, monterey:       "e2c0bd685b202df58f625ec96ec39c27ba64a8dca544d3e2400ad76dd278656a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77e96f7cfca2aa14f76b52cb8b17b0bb1608f22a7b25a9dd51280b83349f2ee4"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
