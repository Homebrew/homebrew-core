class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "6687c727bdd71246de400676e6e67885c93d398f0e45a3b82678cdf5306f0394"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90aa555089355545b2ee0eb2cbe1620702788be8fb56a43f69dc82b3abf0efe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612d14180651d082f1a0827bbdffcf101b8a84bef431abe501b0156efab5ae1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d12c4dd89b31639208e19c00202c36284b305949732f72535d00a325b7b17f9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd9650885b9c9fe60cafdf12f4de3f3f6e17638c301e44c6106388a0afaecf1"
    sha256 cellar: :any_skip_relocation, ventura:       "395a35c5bf453f323d7f1e1f85e95c18d6020c4f6f6d15c17b50608d65b7744b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0be861aa0bb5f6628cc6ab8c888a0e1d76503ebd06538dad258f6f1207463433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d8719838d0b38957785ec0a793ea18042c847c27a730e90d41088127df92e0"
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
