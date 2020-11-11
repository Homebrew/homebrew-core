class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.0.tar.gz"
  sha256 "10308fb78bc5b1b00b7450d812f652bfe6fb6d98d68a0c540bb5d3b9cfd56e68"
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
