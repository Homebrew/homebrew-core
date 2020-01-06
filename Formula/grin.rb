class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v3.0.0.tar.gz"
  sha256 "7a95e3d16d4af52d9a6882b5912ffaaf5bb41a5a45652565114c018dbdd64dac"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e47755a4c84467215c30717440af6de9e7dde7f303e4096966f9220769eb0dd" => :catalina
    sha256 "c4f5424a3554bbdc6ee95761a58c18b16cbb8d8a8601d516d12d9ba5439e366a" => :mojave
    sha256 "86a2b05e7b3a45b695d0556a50c18bcbe0cbd4197cbebc094280053f7a5dd28d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
