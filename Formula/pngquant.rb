class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://github.com/pornel/pngquant.git",
      :tag => "2.10.2",
      :revision => "f10f5d217c170d7aff4d80b88bdc563bd56babef"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "0c675f9ab04f16702cedc535fb6bcab86e0fd0123dedeb3cb770c81bd9bc35c9" => :sierra
    sha256 "538cd28201e8d4f7395c4a6574872be0c3c9e787710f1916c8f115cc91f34cb8" => :el_capitan
    sha256 "495dac84bfe458915bba4c7d89fb9db0ff47baa485d03f4e8c2f97c5a73f3a51" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    File.exist? testpath/"out.png"
  end
end
