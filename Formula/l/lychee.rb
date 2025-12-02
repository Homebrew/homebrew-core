class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.21.0.tar.gz"
  sha256 "15a5f4d1a3c8f8819cc1772c4b703d081dbb4dd57dea9e6fa60e25de8add15d6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9aad7ddba0061dafcebaaecf0e5e76342d6d3a48ca1075f62f8d1b1924d5c513"
    sha256 cellar: :any,                 arm64_sequoia: "998e1c414dc947aeb10e551faf693234436cff33feb6895378ddbac301b53c9e"
    sha256 cellar: :any,                 arm64_sonoma:  "8a602bb435c98709acc321a0a8b707206a99462e4cc6b9e45d079f7b76900180"
    sha256 cellar: :any,                 sonoma:        "438f7ada4a6cf3b6310bbdb5d9876c65a228380865901d116c2ba61b69ca2e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dd4e69f24766ca971ee0c07f47854bbd87e9c9bcdc1273008e11601fb73793f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf54462d3265acc9a9b353db10a9c9c8b2b595b43abe762923f934fdf38980d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end
