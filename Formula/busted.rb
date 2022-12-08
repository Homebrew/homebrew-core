class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "5b75200fd6e1933a2233b94b4b0b56a2884bf547d526cceb24741738c0443b47"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

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
