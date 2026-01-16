class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "1669a4f59ff9e08ad4b38d4212ad8cdd4519209101e3af5459a596d5ad9a7d24"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c6534a3f45a87a5779531495b738120fdde5882da01ba03f6942c0a7dda8135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbcaab49639e3fda91fcdeae70cfa061888dc6137faa92567dc6c51cd23b25ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bfb65b86a24204bf4b2abda3cc81d17cb98a6f5da417510fe9ff1c29feea660"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba80e5bf613babd12529bf470f9e814b588bd510ea5ff1511debf9f7f57c550"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cd46b32b4c0c18cbed0363fd41711375ff26337bb6351f204f19b418975e8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50c29df45f5b59d66bcc90e9c411df9244a57fc3da5ccf0a86f5a7ecae1adf8"
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
