class Jless < Formula
  desc "Command-line pager for JSON data"
  homepage "https://jless.io/"
  url "https://github.com/PaulJuliusMartinez/jless/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3f1168c9b2432f7f4fa9dd3c31b55e371ef9d6f822dc98a8cdce5318a112bf2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592ac9ef0fcac9aa9d7acc793bf7d3e0370938392123d54ef217850a48d31f96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30f5c8605d752a85c2685dbd44efeeebbe853601ee871dc753f68099d9c59aa9"
    sha256 cellar: :any_skip_relocation, monterey:       "aeb3ae17fc8f019562cbcdafd474d98b6704e614db560a6b124fc83125e05011"
    sha256 cellar: :any_skip_relocation, big_sur:        "77bb731c8fc645506b484096a0df226ac3205f474f0a0265beaa899538dc5c3c"
    sha256 cellar: :any_skip_relocation, catalina:       "dd86c1bcee602000bfbfa13b354b76cef7be2779de04231ea94b1003d57dbdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae3618208f32f777cdde437128260a9f44c9ef3ca9f6469f855060e292dd2bd"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write('{"hello": "world"}')
    res, process = Open3.capture2("#{bin}/jless example.json")
    assert_equal("world", JSON.parse(res)["hello"])
    assert_equal(process.exitstatus, 0)
  end
end
