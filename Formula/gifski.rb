class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.10.1.tar.gz"
  sha256 "679474873f17e077036e1ffc19a37c23db1a24b27e880b25aed4620babbfe715"

  bottle do
    cellar :any_skip_relocation
    sha256 "21e9da15ce6c815fb871df71c89f7c5a2ed394e00cc20f8660316c7a86626dc6" => :catalina
    sha256 "3b8bda172112f3123b1db462e42d2e7929ce3711d9d41487b4d2b41f53102e3b" => :mojave
    sha256 "e4c2fac98de49b4eeb103d8deed8822f676a0996695aff2fa5e8d3c10e832848" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
