class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.1.tar.gz"
  sha256 "88416f4c674fdf76cb92cf1b744b4f246116aaf9bdbe0da05a3b75f73f64fcf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fa5fc60ed01176f34aa9e83eda35fcaa099f338b1dcaf27fbd57fff4b4b0977f"
    sha256 cellar: :any,                 arm64_big_sur:  "ca051953818fc0225798c9da1386ca123fe703072e663eb536742a16e9a3c8d4"
    sha256 cellar: :any,                 monterey:       "3a7fefb067f893b85f5a8a41b0eadc9963b2f86763c0eb0732d174f2f7459cf6"
    sha256 cellar: :any,                 big_sur:        "9cf953e7150a68d289afc6dc2c217a7fde47beba38f36923c56523fed33437de"
    sha256 cellar: :any,                 catalina:       "1e86fdf493ac7a145f1a1b62eec6534c1912342fae1d3916fe7eee18e4a22fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87922c0bfd94491dfb41c9ee4f4f71145b6f4e56223b4a288bbfc6122c231165"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 1 OK 🚫 0 Errors", output
  end
end
