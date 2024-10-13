class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "b454979d042e5f55704ce544ff79e52c236534a031851818f73a8744d0851b1f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96085c1b1a144244b4b887f7968c829de3a3e3b48a79f76f205d8f99ed125cd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa2bbaebd619fe57c82b185e20e518a186837f60c82b73b5c9e2fc829e020de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54eee998d292d5db46cf998c96a3fe549ac1bcb61f4e8a3718aec649f3fe6228"
    sha256 cellar: :any_skip_relocation, sonoma:        "d17f738f8b9968511143576d060a7a02f52cf6f01a6c6ba6d5c81ab710a1f40b"
    sha256 cellar: :any_skip_relocation, ventura:       "7dfb31e36759f06e499204d8128815cca0073d96a8dc0de7c1e55cada74bfacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c610c525faa1cc85125201e40fbc924b998448194c150af68b078fb9215a37e3"
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
