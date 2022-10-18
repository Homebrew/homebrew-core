class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.25.2.tar.gz"
  sha256 "346511cd7db1984e1932f2ed29b9e45cab7a47550dc3e08851ea5d642977eaf4"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e419a170d3f4a15fa3ad846179caffc05fbb63cded28a93437b5a3c42865d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0cd31d28dc9320cc9ac91ae2131d2e0bb56c84839c857bc164977ef1f311db3"
    sha256 cellar: :any_skip_relocation, monterey:       "1768ef2130bc68c05d73c298e9fae87a3354fddba10179417a7dc530a8af28bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40f7458ed2065887362f96d6a67aca7ff100872af82547c49f21749b657515d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1d077547e3e0e06b85f42fb4c9868b374c12fe52c472e0cd894429143dc6f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da321ed62f45e71c2b31d07ff03927bebcf8b93d64a879344a678e6a6ec7d218"
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
