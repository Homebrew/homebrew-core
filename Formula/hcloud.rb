class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.2.tar.gz"
  sha256 "e44505128e16013926b469c3f668c996b6225b94d3595c645721e9d146807b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13b65ab16fb45fb1543959e4b061088ec059fd0695086330da61794c530f8c97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae6117be641edd496446ee678576e6771a0746c0941767a43dbbf01dd3c939c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1a229b558069a4c9f2e11613a10e2a50fccd50d217a60d3005262ace8043809c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8201d4a62d1613d98baee9fa1921a6b8add723c303f498c31e6f2d7406e699a3"
    sha256 cellar: :any_skip_relocation, catalina:       "004e2794ce1435d641e6ae4e1fe3a80a8a39f25ecc87b31ca0db5ebbcff938ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c358356ae3d4d8cf98dfe9d52834274e1091278a3194c1a99801817cb11aa6b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

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
