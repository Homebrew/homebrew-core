class L123 < Formula
  desc "Terminal clone of Lotus 1-2-3 Release 3.4a"
  homepage "https://github.com/duane1024/l123"
  url "https://github.com/duane1024/l123/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a13bf57c992f95cf174b53f700b2b7643f3ccbf1863a48c20489dfece1d127b6"
  license "MIT"
  head "https://github.com/duane1024/l123.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/l123")
  end

  test do
    assert_match "l123 #{version}", shell_output("#{bin}/l123 --version")
  end
end
