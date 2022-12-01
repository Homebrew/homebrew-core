class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "be932924cf1799d6e8493042dc7435ab1d95ed046d7a06ad1d358c7409402a2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74976b6deb3f496c4b0095ac7dd8691e023d9d17542b79b44db1d11c5180015f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403f7b72378424e98dc9191d89af6201899ed2884e85c04f83d2211a1756b72a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56dc91f0e6221da27f906dfd4df6b43c336245eeddcecdfb3926422365999c7c"
    sha256 cellar: :any_skip_relocation, ventura:        "cea88ca50899e3e5a86d8b6344471d8cddb5197f82b2f642484ba6dcb87d21ed"
    sha256 cellar: :any_skip_relocation, monterey:       "619be05d98e9f9e3997af5fcd0d24535e10f821034a20c34fdc1c765d8e9ef89"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8ae6c8036e92a60eb588ca87217b6811a08986906d14473427edabc1b6f000"
    sha256 cellar: :any_skip_relocation, catalina:       "bbec7c22131249c4ff369c33475e20fe26d81bc5eacac6b10fe8a111bb879fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c19d9e7fb386d94cad00123105f482ca075207ecf1b32e3a06d7c50df9328a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
