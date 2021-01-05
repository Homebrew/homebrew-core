class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.3.tar.gz"
  sha256 "431cb2e2eaabb3ebe06661ad84bc883bda5500ef559608487c91842a0ae76ea1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "22501fe46163d2c9c88dc66fdf1babc314e58d151cf0ce2547f742d846da0d97" => :big_sur
    sha256 "37060778a44559e4b1f12deca73c61c724877c97f86a39e77eef294799962076" => :arm64_big_sur
    sha256 "d06a103b94a394483f8bd916e0d30812ccdf46254591ae56000a81fcd68b2713" => :catalina
    sha256 "fa5dc699252f50ecab26aea7edfe4c8e5fdcd21d06dbdf5efa2a09a79f3c3187" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
