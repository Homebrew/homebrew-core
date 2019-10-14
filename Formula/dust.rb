class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.3.1.tar.gz"
  sha256 "a10e0b2bc5862928a257e05866e077866193cc673d97a711ddd63eeecd075867"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "904beff5b0241fdfd9e2b6652b1f8d3cc5ef377de93017e87a9e0424140befef" => :catalina
    sha256 "caf307790a9330aff377bf16ae36bb252c035fbf1d85d588265960ffac90c3d9" => :mojave
    sha256 "3c80e045eb935b00192a88e5d00dece572506b23428d795dcc1ed93a3ff01ef5" => :high_sierra
    sha256 "7e703fb0f7cee5e151432fe9522e3050f90de399dc2502d8618edf9ab58ada86" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
