class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.1.0.tar.gz"
  sha256 "a375ed5da0cd12993001db899de34990135491ec01f32b340c446e79c4a9d57f"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
