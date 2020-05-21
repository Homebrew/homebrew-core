class Eva < Formula
  desc "Calculator REPL, similar to bc(1)"
  homepage "https://github.com/NerdyPepper/eva/"
  url "https://github.com/NerdyPepper/eva/archive/v0.2.7.tar.gz"
  sha256 "72b2e47e987102d67c9dcbb60e26c4ff0b20e6f844d0d2b9d91c3f073374aee0"
  head "https://github.com/NerdyPepper/eva.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "6.0", shell_output("#{bin}/eva '2 + abs(-4)'").strip
  end
end
