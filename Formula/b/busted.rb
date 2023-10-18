class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "445519fa663dbdd21e8a6ecf1609f397d0e2168440e59ee29198ee687321e9a3"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a28188f4263382669b0fe05dbd436442f033336304d74420f03708ee0274d478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c786f9112dbb02465796371299f4bca901abd098cb53e09a9ec32b49ba413449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1206262092a4f062485f69c3f6089ca83860d690c3ad0106c5fb66dcee5fe3fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1add1b2ed97a73461df8dab0e780fc330353ae79c418f08a2679d881911dc0ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "48b47c0a308a67e7af702ff6307137f9e02ba39e0866692270a0574682d49d5d"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e7507ca4eea417efb556d1c9f41f3032ca2b64fcf7d7e85fe984b7d453a3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a1c8e26fa76b9de341e1494ee290dba46f8a060a3c7a3d83b4823b2d755abc"
    sha256 cellar: :any_skip_relocation, big_sur:        "fef0e53feb7b809d09cda5fae2b28cbb4e0b61533682a1310e1a2218d3a7d46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6c1c7983b53105524d459212b180473c16f2787870ef38ef27e6e9d9815bdd"
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
