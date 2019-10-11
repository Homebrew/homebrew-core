class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.9.2.tar.gz"
  sha256 "e2f6a44e5422527f1a6c582f371b637fefa9f0420c25cbce5831b1c95a2c91c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d8357f6ae4d8649a6cf39cd22958cd977c804a5dad275db0ca610de5b1f85b6" => :catalina
    sha256 "f79804792744ae8dfffd5a64164bf54141fff6a9014a5eeff321b209ed3ccae4" => :mojave
    sha256 "7922b291a3e8d0d962de2344c794fdc14f084774099ab1a3c082f8ddf9d2d2f8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
