class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.21.0.tar.gz"
  sha256 "50767ca3dfd1fa050d93409bee4bbdb49b021ef4ee2329c788efe5016ef9e28c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12691c0b915a440f422843da4b2bc21e990adf2ef02713028f76836e8b6167c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca0b666f8893b6445d38105eb337d6ba2f59143915a5fa8f5f53eedef72f33a"
    sha256 cellar: :any_skip_relocation, monterey:       "3e355cc128bff0cdceea0aa828a35450b67246d089f53b1f78a2ae83ad214c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e7c9b2cc2f93bfba3330d522a02852d1dcebbb0e86af02196e9d20951015a13"
    sha256 cellar: :any_skip_relocation, catalina:       "7bfb144b0153aa243ddec22468a87601a722b0defb21c30fb0d9d246a780d014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f657ebfb82791edd0eaf7e1c6eae2bb9210ff048b8d6935af618b6d0d4f02c39"
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
