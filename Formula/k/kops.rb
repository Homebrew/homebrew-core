class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "4bc0fb78048a7d6868f0ffb8e07ad6108fa4b1d513e1e1d90073733acae3ce25"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e395d8a4e0729312a7f5914de6912b84bbf222759f90abfe2ee7042b9324aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24e6c1511878b48920d97a7d96830f17c974ca779fe996b14a3b22ae0be4c2aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5228775956709d7b613679f28a19ade1e4b8eb77e4c4b77bc83547ccdf2d1c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fc56e5a22f9ed86a9fe56e6d13fdd306a425b020ff9b56795d5feeb39155a3"
    sha256 cellar: :any_skip_relocation, ventura:       "9eb23c22f063b3abea0e85bcfb8b7fa6560f16f1828d22d6e339509da6385860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0cd3ca8dbb680e200bec0712fb9d1c06bd28150b076fc38368865de5859aeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff3d46376289754e2afea450b8bf987b043143abe89b9b4663bb128364fb906"
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
