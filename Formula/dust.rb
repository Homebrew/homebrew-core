class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.2.tar.gz"
  sha256 "15f0d3578eb54e15fc502237c1d7f9cea62037f1b62b5a8d99641f12690d4a95"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f66a74fbd7def9b4bf0bdb77f2179caa0b61b18ad22cd401e4ff85c5a7d6bb4" => :catalina
    sha256 "eefa1e6de716f8b880dc1ef6bb137a5169bcfc3a4b1ba41a7f54b20904cbaf27" => :mojave
    sha256 "98ae783e45795c50a21d2dbbaef947bd000b194a2039f4a31cb309964b44bfb8" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
