class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "deed90394c3955bca86a068bc52c38a71764e4502eee7ff21c335f01ac8a8a5d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4cde6061a12b1b85661929028d28eda6840b81ac9f3b75acf731dd369537c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b28db349355b5ade7fcb0cac9c9968f6e1cade722827dd665106e7e77451f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba37495e3c27ad4df6b7970e0e61b8093354963057eefa4592daea04aa7993cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c206af02843445227a2bb8753a7f4340bb3aa84458f97ff487e6c6efa363ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d981a3f90f9fd396fd969afbff881bf7d449bdb1a3c52c5c6088bddf5760491f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ff10f3bd9df541929cb5a428e3b62d290bfb98e1d49906b3667683e5d81494"
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
