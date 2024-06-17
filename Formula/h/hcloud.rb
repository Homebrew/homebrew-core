class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.43.1.tar.gz"
  sha256 "5bd9e55b7c0877ec51cd1f3d873d5c1f7447cad8cb76dcaba1f3c5186e7f02bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ac108adfba4af641a395f4e6c1db287179942f84ad04d292162ec0273342d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51fb3d01c2d1a60d791c10b20b7837e5bbdf4213b0160b24a2a9db1a682b720a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a01c05616083eab7edaf25e1ea7f7a1ed5b95eb92d2b497614839c65c23d9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c90eefd9252f709cedc4f3e0fe68ed468c147972151de70153f5349b3a072fe6"
    sha256 cellar: :any_skip_relocation, ventura:        "4e4c0527733f49dda1a6facefa94efc4a5c4908f3226425c0edc1e209b1f5a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a59812fe374523667a598b4d5ae7bb29b595e30adb3d28efe03190a449ee9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "504a227412285691384620d6af93e53eaefaac8e13608215206f33be9fbb6292"
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
