class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "62e5f363758958c5034f0a8c5a907f9c76c37f7498f0817726d9b8cb21eadc87"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9fa3174816e578e1c6f5e4801d3047ee7130ebb646dfc71990ae8d1eb120305"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0d63c1b1027602a6da7448a24307595dd567a24618368c2165ba26ee7ffc1b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebb529f5868af0f6fa053cdbbd1fd21ce55f63642230ca26a766452479780740"
    sha256 cellar: :any,                 arm64_linux:       "e07d680be915403fa69559ec9fa2a56ef647523221933124b993a1ffd0cafc04"
    sha256 cellar: :any,                 x86_64_linux:      "ba2e22dc7bb23979de34a43308f9ce04b50f06f14d2dbc1c0f93cf25a56d1d62"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
