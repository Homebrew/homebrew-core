class HtRust < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/ht"
  url "https://github.com/ducaale/ht/archive/v0.6.0.tar.gz"
  sha256 "a990e2973cd62cc483dc875e5ee880bfdd759e73f8e6ccf63b188092f7d9f293"
  license "MIT"
  head "https://github.com/ducaale/ht.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89da38044281fe03f6870429d66ad499a1c94e30293fda5ed833cb5590bb0617"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2c87c59ef867068f56acf7c9391ce1517b28a5245ed4e25720574568a230b86"
    sha256 cellar: :any_skip_relocation, catalina:      "113ba41bd6f22cd7b0962eb7906004c4189fee5ddacddb62c1c24e56b98f0e0a"
    sha256 cellar: :any_skip_relocation, mojave:        "af09c8b2723fd151effb7050fc767db573ce43d730f6935506a7868c2c27249e"
  end

  depends_on "rust" => :build

  conflicts_with "ht", because: "both install `ht` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/ht -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
