class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v2.2.0.tar.gz"
  sha256 "a3f120b4139fe0d4c41aa6d4b050411da1e18ca7b6271bbacccdc974175e1853"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ea1af061a0ea0cc9995d14560888b4707a07d5970f0378964fe1a9710b77e72" => :mojave
    sha256 "958aa7690a265a5b47cb24671972b8d89f1eef3d7fe4e25f7cf9b2e1c65b8335" => :high_sierra
    sha256 "2f01a2dc5512754034c7b1cf0ddc8369ce60fc6e47cd189a0cc311edfcfd1415" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
