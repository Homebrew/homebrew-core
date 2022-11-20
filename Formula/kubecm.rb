class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.21.0.tar.gz"
  sha256 "50767ca3dfd1fa050d93409bee4bbdb49b021ef4ee2329c788efe5016ef9e28c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da53fe957ccec5fced1f7b1406f68f0180890a5c6d29384bcdd4d5898cdf0834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595be4ef9cdce6336d7a43c9dfc0d67baec9b9b167e6310465b9b8c0db7ad595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdbd1332e1342c67ad70f23cc79ba14ef91cc3b0ca6016252b127d0ea7468922"
    sha256 cellar: :any_skip_relocation, ventura:        "401c12e8cc6495e10d0c04ba9e478df6675247da68ddf7121a32bd194fc96015"
    sha256 cellar: :any_skip_relocation, monterey:       "f40d4d436547c7252ddbd572efc4465b5a54561733b0c9bd7f185d6a24b17a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6fb0203b3bc20741a42e0d97ddc0b102a54864ba6a4b617410ed69df1d1a739"
    sha256 cellar: :any_skip_relocation, catalina:       "6dbb0621f4a68ec640400ecf98c2a09921313d74badf1d67f4240601ec095839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6264ac4fee941ba35a2081eac068207b45d161e43cca2136fe89eb8b01451c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
