class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "445519fa663dbdd21e8a6ecf1609f397d0e2168440e59ee29198ee687321e9a3"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a1a7e69313f1ffbcea6f2a14c3ded1a28e7211ed5e1b0d368e30dade4d43d07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae0a45974b644832a62c5328c2ea0a15dc3ab38ff975f7adaee4db85051984dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0856fdcc1fdd7997a28f1d70a70fe0a5909b9ac42470ca39bab8c038d5540f8"
    sha256 cellar: :any_skip_relocation, ventura:        "70d5e8bd2997df38cb674f5d7466706a536007ce00e7ed85809f982d2e8fb03f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5b41875dec98d94762d3319857ee989a567ee1dba8018caff2052c03605cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae6f94da27bc893f5e59c7e194a34ff9884d70d798640f4f55fc5d810c779a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436a10b61213c94b2b3b2148dbc7c17eb9f59954b2694ceeb0eb086543b2befb"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--global", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.lua"

    test_file.write <<~EOS
      describe("brewtest", function()
        it("should pass", function()
          assert.is_true(true)
        end)
      end)
    EOS

    assert_match "1 success / 0 failures", shell_output("#{bin}/busted #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/busted --version")
  end
end
