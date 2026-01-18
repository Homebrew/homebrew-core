class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "f6b61d7be1aeafc4f320b289c5d63bd405ef2f8abbc0ced57f7c1c10e42b51ac"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2690e0e0530931568ffe02fc1fea8248be5d13039cacf428dfcea091d4a1fb5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da7197efb9b217736e7332ab8c1bc23c9db7415877adaab37abde7f92f5499c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338f4822a27d9a2a9d3319900f892ace54818cd21d0df62d2b6727a299e9b582"
    sha256 cellar: :any_skip_relocation, sonoma:        "241a7a05d02d702fe2a3526800a7c3583a3b7809b75f0cff3ec0b166a962d1fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eeb382f1afa71c974f4921f458539d6ba6e0889c45a5b9e7bcf531bfa289474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d5b59eaba1844c00735ed8a2f6d4553aa74a81c0a81672f8108bbeb1027e0c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
