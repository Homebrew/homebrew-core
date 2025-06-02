class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "a6b1a0d2033b043c1c3b31ff9076c4b5a057fa31ece314c1bd39c2f690cb1d00"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690f5f68cdb70733027e5f76fc2db1285d9733fe6989784a308541ecc9702486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef35b29d2805bc6f205c77b15ba3a6a9ffa4d1e6e908251da3b4b3febdc8866b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5c1efa010c2360ec084127ab0bcb1ae8bcce89dc7bbfccfefc36b169b692dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e782ba09335a3c20e7babf269e447f49e7d15ae31cacff3e4d6a67b607072ca"
    sha256 cellar: :any_skip_relocation, ventura:       "2545f3353c387e8032b0b0fd23c9d472504a4f66db57914fcc978ef5a25a642e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0547a9e5548b3d5fbd1a2208b7a0ce9feff21d75c2bdbdfe7928748cff783f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef6396f2909545de80ebac7b39348f7238e92f20fb68823aa8ed84257db1cfa"
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
