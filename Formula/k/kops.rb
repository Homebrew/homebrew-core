class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "d3529df848f5c6c4fbceb42d186c8e2a8cfb9ed87caa0d252b4497604bf7739e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbdda10847046641edb68dc942443f4ca1f9cfabd3783b12eda0d30651b9ce87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76799720f6980f21d5c17de971eab4bd038993241a47941b4f02287cdef3d431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55110c00f2c81ca4ca44be6d22511d9ee69d7da1407de89339394116753fb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "16feea6167f6b7af6f6031e2de0d3b1216e566d9e3c27d28edc6c40a6f32faa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b963f86d75a2bf67c15a21bce175ef697a9e32dd391f50d4991409c854d3601"
    sha256 cellar: :any,                 x86_64_linux:  "86ac0698e2a45061ed22bba9e9f1676b241a3624f7c531b2929606a62b95dd18"
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
