class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.2.1.tar.gz"
  sha256 "50fa29dec01fb4cc5e6365c93fea5e7747506c1fb307233e5f0a82958a50d206"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9864db5e41a84b93dc2def0fccd28d456ce9c0de1ec873f62684678c0c7642e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d5f863e975748707648c3dbc3e9cb41e789ed33ffa279294f532188acdb41c9"
    sha256 cellar: :any_skip_relocation, monterey:       "67ba03994f9aa78abd09282ddcaf8ae7cd86c540ac1dfd3cf81c21216aac5f4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3cb468ecf4fa42aec7ae88067a7a8581b8250a3daca7424f511426b19075a79"
    sha256 cellar: :any_skip_relocation, catalina:       "1a9b869428024236cb956bd0cb1899e2d0b994ad38ac85b7bcbd2b0c177ff280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7092bfbc1dfd91dec09cf6ab70d5cc51839e84cd26c1e7a63c9aca2231e8d284"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
