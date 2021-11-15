class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk-rs.github.io"
  url "https://github.com/mdzk-rs/mdzk/archive/0.4.3.tar.gz"
  sha256 "47b3333268ab92d29a2a0c017bc7ef93df82a657b42a00e5042492d51d466af1"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76601fff050c7c2fa3aebe94dabb88a6c29bafc45a46e8fe602ffe450c2b6785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca7eafe6a001f980751289093aa0cf750c3d76ac2d541c2c432118e90bc98c23"
    sha256 cellar: :any_skip_relocation, monterey:       "65b07939544a1e5e8771eb338f0531f3384c32de001ae5c9e95db66a6a74fc9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "909badb5ce6a0a36ee66a86c88a8c2058a52e10d41cbc67961a86c01905a8d76"
    sha256 cellar: :any_skip_relocation, catalina:       "fe6ebe251985b9879a03338bfa4668c5b39f064b354813e0a693dc19e7b9eedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af069e55e599b7789f81448c6b9febc544b6b6d3076abdc7ee82a19b6d55ca51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
