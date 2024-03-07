class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "b99ec2b89d1485c3b14d6db2966cc355c9173ca98fe29754216b70f72317d8ad"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f9d30816361b29c44ea8168d072a60827af6d37c854b4b35db973ab7300a2fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56050ac5a686d19e8cea446e33352941fbbfc93796dd2a935aaafd665199edb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ea6032b0f670bd811a9b0dedb1d7c4ebe0427d1fee8651a88c256b687bda80"
    sha256 cellar: :any_skip_relocation, sonoma:         "d49b568974dc325394a8fa12234f43a3cf1c3c0d7ffb886408addda8b43d9498"
    sha256 cellar: :any_skip_relocation, ventura:        "7fa5e5e2764da50140e6b47da4d8edccca8df58f232db781d4512af922fa5771"
    sha256 cellar: :any_skip_relocation, monterey:       "958678b32c5c8bb45fcc137003384ad5ed5604209c51a1a75aa9f406ada9a4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421344088abb8db10447221b51eef0abc77acf688d0d860eba0c1597c8463e1d"
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
