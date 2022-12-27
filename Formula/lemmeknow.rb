class Lemmeknow < Formula
  desc "Fastest way to identify anything!"
  homepage "https://github.com/swanandx/lemmeknow"
  url "https://github.com/swanandx/lemmeknow/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c2edf419aed5d2f9428d094dad627a6205b18da84ac25bbc2879f0ebc39c3801"
  license "MIT"
  head "https://github.com/swanandx/lemmeknow.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/lemmeknow 127.0.0.1").strip
  end
end
