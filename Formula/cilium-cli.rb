class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "755110661ffa806ff4129ab820a4297c1d80831401b5947545ec50dfd5e79ba8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f5ca12f93afee41adda71490c890f2512c5a088a8c3c985e1cd2ab8b32a9be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7991a870fb3cfa9bd9307973dc94989cfa3a01a32fda7e647d222ea11e750aca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bced7d43ee31f4b70369206e8fe4380db9aa8382e15b1151c0f65b8435e38a86"
    sha256 cellar: :any_skip_relocation, ventura:        "b74871870c0e41e3989fac756a42e6a458deced25fd2e9f4a606d0bb9573c452"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9eb223c4fefaec43d28feba42fddeefd2d342c4879cc02473f2c2025052596"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc4fc2dade312f806dac2ec42d777b7f95027b8c79d6bb64909fcc529f5da5fc"
    sha256 cellar: :any_skip_relocation, catalina:       "0e171ed7786e93c33969d9880daab4f8cb39f5c22cf4ce8195d0a942ffd2d778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca9e40bd0d322e8949916da7a061ed14a68e42d900d7b96e54267bc5c9bd55d"
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
