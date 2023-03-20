class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.11.1.tar.gz"
  sha256 "b5ed41f8c91e888d1aab841df6adb265281344ebf0ac9ab9050b11700fd84d7e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ff35477acf578b7954b428e087b3e287429c26c9559205f2a2dbe5f6a0afcf4"
    sha256 cellar: :any,                 arm64_monterey: "edf59cd06b0c3c93dceea7ce20d524629b4e410816bd13387400430e1afaea6c"
    sha256 cellar: :any,                 arm64_big_sur:  "2e638f5ac82e3232e91a3c9855bd3ded1f938faf47624e81648bf0ac7a83194c"
    sha256 cellar: :any,                 ventura:        "cad927cfbccb5fa985d0938899426f98e59d4410823013c268041d4ade87459b"
    sha256 cellar: :any,                 monterey:       "70a679466975da3309a74aa7ba23043680f35083b6baca6f4d41f284e1938cf5"
    sha256 cellar: :any,                 big_sur:        "aa4347b807a7da8dde526b663705cc7185c0fe56cd90fdd931006cb4d55b3f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5b2b014a75863b0a1625eb413ba93d4bbace4f73b250c10a7de1b456ff43db"
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
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
