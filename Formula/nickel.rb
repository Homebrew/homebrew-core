class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.2.1.tar.gz"
  sha256 "50fa29dec01fb4cc5e6365c93fea5e7747506c1fb307233e5f0a82958a50d206"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45f1085309099c03072693529e3e985d08483448c6a5c328db63a1a8b01f02db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "323099b4890442f87b62a59416bedffb8047f74a0f33bd44738893b4a4ebd70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a2b4f73b25f3bfa80974b0106647a0becb5662feb04429f2c9ed41d0135144"
    sha256 cellar: :any_skip_relocation, ventura:        "a919fe30f559aac73698fc5f169516266457e0de15bc83fbdfe6a1cd44fade24"
    sha256 cellar: :any_skip_relocation, monterey:       "594bafce3a8793da94a73838b872cd41799167d515425e5ba8aefb79077b4613"
    sha256 cellar: :any_skip_relocation, big_sur:        "b50e4f1d2decac26424a500bdd1874522b36a1023077620e315cfa37ba1799dd"
    sha256 cellar: :any_skip_relocation, catalina:       "fdf52dcbba45229a18772b625b5f2783af7d678652eb41db018f96d5cb67cca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082449483169a4d0b8143a23cddede5037ee4c47830557186a5c06fbc97477ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
