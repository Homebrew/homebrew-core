class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.1.tar.gz"
  sha256 "1ebc71f8741d644cdc1fd3f5c2f78f0991bc56e038c1132cbe8c9eee144c8f03"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "045354266f0c2bb6e9e65ef5bdcd1778519780525c4282ef91c94d8da630f8d8"
    sha256 cellar: :any,                 arm64_big_sur:  "5b645d03eaae816722c517f5759a11985317534fd7a84406df74292fe2c02e41"
    sha256 cellar: :any,                 monterey:       "1303c5d53850fd895face8f9e9aed9a71f6445b2350a79bb8600063e04b914f5"
    sha256 cellar: :any,                 big_sur:        "e35c6eeaa4318fbca22c85a3d9239c57f7db3dc00f070c35832f07ce23c1d007"
    sha256 cellar: :any,                 catalina:       "e8a8ba21356135c05f6e2c095f86864f14bb7c0dce1046e6f19d2d683c24683f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0ca5b6fd5fa6461a11c12e1beace23bb1d8de8efdaf9f2af73d294156a6e38"
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
