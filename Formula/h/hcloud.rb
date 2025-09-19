class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "da5725ce88bec0f71ac1323874ad9d6340270b6047a3383e36063f5b55e3272c"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3cbec9f4636f748e875b2e05374576624315141589ba150f289284301bb0c2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445a0b523bc5fdae6280b07a09559fb9afd4ecd887a5bc3b643f62407b4577de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c981ed5adf0b444b1abdabbb7b71b3108b5958789c8fc9ecddd14d104bb6e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b4e329a86d84fab27e851b443c34fc4f402f92df969eef1a286937d058c53c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "73ded0c7c8be21fdff1aa046056c46f0c6086105cd20076749294a8037f2ffb9"
    sha256 cellar: :any_skip_relocation, ventura:       "abd8146fa8faa08baf31e127132754ee44d8026d514b3f90156ccb6ecf940dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dc047eb117ec1be071bbc6ee4de0d26719252538690f340b4ca5021b9b19cf2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
