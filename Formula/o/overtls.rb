class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.40.tar.gz"
  sha256 "b88d27e6418170e9f6e4af0df0947c43b8a100299883f3e13b5bced47d3da341"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "966ed640e3a64ceecfad54085c1da8d4c85a01acb2ec5b4eb6f93e6cf29a0373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27fe4b93add2cc49e1181b85afacafb838da9dcca9f4f271b8eeb212dedc2a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6c04bafdda5f46b5f3e899dc392be0b1e0f489247c75d0f0a10c714cf090a18"
    sha256 cellar: :any_skip_relocation, sonoma:        "390f44a9f33deee49cfc9b585eda84bf36a9fb96dc8283d5a89ca5028c6ffed1"
    sha256 cellar: :any_skip_relocation, ventura:       "49ecfcba321ded795593bb86deefa088e4db0cdd36fa5197b1fc50ffead84e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48cf786fff3a56fbb364e2953bf960c7518f7f299f9a4c8b2e2ad3549deab9d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output(bin/"overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
