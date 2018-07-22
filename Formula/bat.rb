class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.4.1.tar.gz"
  sha256 "3ae66854da59d691b8740672708a2e7f2f240c76e8a00283f59a6e39127e4583"

  bottle do
    sha256 "71b1699808d53e309b190f9e19b0933406b253dc92628fcc573e5d0d0a2ca5df" => :high_sierra
    sha256 "0d02ad1df0fd35b32a802fd57421cd0d2d875481bb6926597cd20e0027722604" => :sierra
    sha256 "54964875e1b9ea24d58137296b5bf444cdf001c721ea5200792f29686e024db2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
