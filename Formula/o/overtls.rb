class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "0b3c9d82bf8794e1bd6c54b50b233768a8dd621f2212077210cd930775fc5d85"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00630c9125c122033f34dfa4c73a2b46430758e731fb36e5ecb4299984d9f2bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d380644ece6bacec93b39ff99c61231234b6b182a9d6735bc16aab75828272f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f2981040963b65fc7e428b0ddc16f51d7fe9a67b17b354c578efd7ee92cfb42"
    sha256 cellar: :any_skip_relocation, sonoma:         "c651e2f40a5d462df53681295a60b5e7128c03cc20558d71b27ade06de9d8b4e"
    sha256 cellar: :any_skip_relocation, ventura:        "d1776b267bfba9b20906f3b8459dbb9e5d9032aea6ab443f69186b9e22aa529d"
    sha256 cellar: :any_skip_relocation, monterey:       "b420b26d4d5fdf08751e488b7d90a914a7458ae640eeb791d8efef3f3b5f1600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b229edef5b47f8ace5fdf012a67d8d8bd552a93aa1a5fb31aaa2495a30689e11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end
