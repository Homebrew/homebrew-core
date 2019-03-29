class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.7.tar.gz"
  sha256 "e8d8d2fdb816953315989b3ecf39ac88f33b8c49aa7c79a0df8f53b4032755ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "41b0c73f3364637a793137b5ff167847f04104a29ef1db89fce744839786f20b" => :mojave
    sha256 "33268907c1359250acb2993847a179ae6dfd9c0173b9c62def3dfdb41168072b" => :high_sierra
    sha256 "7a4cceb9e6b9ea907dc9244ae6e7e2a44069588034ac7937eb642f7cc1252ec8" => :sierra
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
