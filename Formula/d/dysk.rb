class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "3a1757886313b738d422daf90b89a88033c417aff9e7f579a78c8626920e9d78"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abf7fbbf82038589623dc474d4831f2b6ce0a10b02e0ba61a8658a16f5c97a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72ff366be6be4055bb7d650e535259e5dae9970b95539dc9a52fde2fa7536b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b74efab157c3abc64ad22218e7832b80478820f28b7b362591e1b04abd0e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "31913c3e05b47fc003450fd06cd5f84b0188a94c4a9a7e01e287206ad6fdfcc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915b3968e44b7e0707f32c8ea32aa48bbbdde49a478e859ea3c9d85f5d982908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0fd6d121d7daa86ea6b01a4452aca70417f7640321928b662dc3d205ea63c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
