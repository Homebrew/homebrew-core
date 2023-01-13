class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "1914686ff67bc852948a58fb95d6c438c824ce3a4d02f9b501b4a8770991bdb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eedb097db64ce8f52b24adb44a92ca23bd634d648858281f12481955c5de4f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4acdb55de4da41aaba13734f299b68c724b5da69c432d5c77f8c0bc96f9b649"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d341136044e1bcb7a3d39737faaaad626ef8eb8dc6eb945988fb0d1afb8d11"
    sha256 cellar: :any_skip_relocation, ventura:        "985ed15b79ce843579b3b90db42f021b2d58de8d644c2a99db31908fd824fffb"
    sha256 cellar: :any_skip_relocation, monterey:       "57d40f4bc09b70e0ee18afe931ca6a89515961789768e90d9a3e5a7ba3a647f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "97f3be2338bd83770f60f731d4be97dba647835ede8f683fc071f77fc8a7fac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af77c348eefefa3fd5e500997fbb379468f15a13bd712d8ecef220dc15e458d5"
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
