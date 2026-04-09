class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "1669a4f59ff9e08ad4b38d4212ad8cdd4519209101e3af5459a596d5ad9a7d24"
  license "MIT"
  revision 1
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b365b5128600da6de31d3d468d99d5008fb2c1a359362de3fbf7b206e9b307c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb42897d81c69d3e00608baa5e8794c24cd5a8e7c88630d94f2c123b358b962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ced43b2770a173da2f8ab203fc0014ce265728fcdad2068fdea82c29b0ef78"
    sha256 cellar: :any_skip_relocation, sonoma:        "71b2b448322e152cb75656508cad75d28fbec3a66dcf804d87d9c8621853428c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7031313aeb06f0e4cbc1610759e962b0494670f28707c7843248f74ece309e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6f66483354265a0fb9b8648ca9038154805516078072e888c56c78eb533bb3b"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--local", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_file = testpath/"test.lua"

    test_file.write <<~LUA
      describe("brewtest", function()
        it("should pass", function()
          assert.is_true(true)
        end)
      end)
    LUA

    assert_match "1 success / 0 failures", shell_output("#{bin}/busted #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/busted --version")
  end
end
