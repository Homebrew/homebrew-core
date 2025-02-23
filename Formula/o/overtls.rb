class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.40.tar.gz"
  sha256 "90e6e68822f9498661af958977180735f94f746e63e1f20e87614758aab85cf4"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88dd59b291f6556f689165e78f942176e8a1f9ad3bbf7ad9e8cf093b842f553e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e06ff2d16d1ec617c31ca907aef29e9ad53b1a4fc6d56d8ec19bd73d5d7a4d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e9375f41cb4864229114f839b52361987171f6103dfaab4404e0fff07c55c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d470d3e2ca6c8d526160f290b729e21d548cd0ce60ceac0bd71ac5dc568a3ba5"
    sha256 cellar: :any_skip_relocation, ventura:       "1836719283d1a9664ef3cbe6e459d033f72a1d2309957521a405efe8903f4c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3947b15cae08193a3c6f26af63ce2cc8d73fd8bdad9533a6321f3d84e971b77"
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
