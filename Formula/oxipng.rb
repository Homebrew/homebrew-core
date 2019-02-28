class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.2.0.tar.gz"
  sha256 "a3f120b4139fe0d4c41aa6d4b050411da1e18ca7b6271bbacccdc974175e1853"

  bottle do
    cellar :any_skip_relocation
    sha256 "0df1083f9bbdb58dc3d446e9b3a683c3f3c6654ccde841f8172649e3341b726c" => :mojave
    sha256 "9ab0b14d2af6f705239ee8b27b3c99bde6e30f35067d7a1c05b4e6b45d8cbfcb" => :high_sierra
    sha256 "1b70802cc119c34663aa10c6a40a667d0ea5650537c8b2db9ff2bf12569f4d78" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
