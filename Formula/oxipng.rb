class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v3.0.1.tar.gz"
  sha256 "31b036b146d087b989c22111637129ab8cb29a26719bfff1290427ff8b595e11"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b718645e952cd09e9b9b950b738bcfa7d81d24d2ccc94d3db6c76da1232ff932" => :catalina
    sha256 "b646164d98e8fa1cde4ccd2f2f00620f43a14dbb3c1714c24aef9a49c4cc9e96" => :mojave
    sha256 "b99d3c1bd4936a71b6948fca53644a2791efbf59260b57d3bb2cdea57ee8c746" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
