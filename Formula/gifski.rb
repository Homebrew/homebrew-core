class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.10.2.tar.gz"
  sha256 "3ec058c9d62c5411155d1c9a59fe23d282eb569b480cf8aeeaba522ead82b250"

  bottle do
    cellar :any_skip_relocation
    sha256 "30437a900fa860afeac551709a312459786bb6c865d12ab59fa2b21b1d99232d" => :catalina
    sha256 "99bea8a44dd6fb7bcd6f1a8e97633f51d3908cd4552ccdf06ee6565a6d8bdcc7" => :mojave
    sha256 "b21e3d6c483d981b05b57cf09b26c5f41ffe5f3ac4a7d759db5258c1fd5c88dc" => :high_sierra
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
