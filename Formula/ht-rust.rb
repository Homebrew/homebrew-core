class HtRust < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/ht"
  url "https://github.com/ducaale/ht/archive/v0.5.0.tar.gz"
  sha256 "ca478874440df533530577d8dc0867208bbf6d5400b34008726b75303a87f36c"
  license "MIT"
  head "https://github.com/ducaale/ht.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d5a821858a26bcd63b8d7d3dd13a03696eaa62426d573f54e441af6dec2c495"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5273e5b99f250e9cff4643678f46a4383e5c07a9b5ca3e7f55d7abb24e3e97c"
    sha256 cellar: :any_skip_relocation, catalina:      "2a9205e969a23615ae1951e98d7f9fe59955f89eba380f1ccbad82bfbb6f3e21"
    sha256 cellar: :any_skip_relocation, mojave:        "3ef31bc091ac3c0bb4d6dba576383c4d2d1acd5fa37f3e9194ea5603bb064ee0"
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
