class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "21c52aab5eefb0fda578f8192dffc5b776954e585f5692b87079cbb52ac1d89c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "924b3ce2bfaee2a6bbe294de6f330be63bf35a16377f7f3fd1d17bd8bea233ca"
    sha256 cellar: :any,                 arm64_ventura:  "c6521df6fdf60325b68a4ba3e8e54f43491716a8a8f656b54b9c00d0e319e803"
    sha256 cellar: :any,                 arm64_monterey: "c87eb977a24d7c493ce1647593a4509deac9a5485acf48c35521ccc209cef3a7"
    sha256 cellar: :any,                 sonoma:         "25c1855e06584cc7a09b1f0f197a0500206435e0046fa6311aedbe9d4f8e8a86"
    sha256 cellar: :any,                 ventura:        "20646313a781d98048858aea8655c5799135622158bddf49fde21da4bc4d14b8"
    sha256 cellar: :any,                 monterey:       "a0e1eb289a41db8c30191e08f77709ed634d97fb2e503e7e40bd78cb4bfc9ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be7a8b341023b5b6538713fbd6eecf6a1ee9bdbef07fc08e31be67fae8cb925"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
