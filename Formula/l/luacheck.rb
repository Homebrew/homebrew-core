class Luacheck < Formula
  desc "Tool for linting and static analysis of Lua code"
  homepage "https://luacheck.readthedocs.io/"
  license "MIT"
  revision 1
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  stable do
    url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "8efe62a7da4fdb32c0c22ec1f7c9306cbc397d7d40493c29988221a059636e25"

    # Backport fix for Lua 5.5
    patch do
      url "https://github.com/lunarmodules/luacheck/commit/eea104d82fa66f27df2a7d900b3c271a6ca122ac.patch?full_index=1"
      sha256 "94428b33a30a6695b6fed1aee7d065c7a5219165ea645a68d106e3dd375274af"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47abd7b613466d911acb17b8e58f503620b85ede27555aa5dd7961e98d7d3bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1307faab569321d52282f0d80841f030c52f097545489d3e538229a5cc605883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dea250ce1ef474d4d52aef628332f449a53eb0d10aeb1b171796ef545143573"
    sha256 cellar: :any_skip_relocation, sonoma:        "5710f2c553d6237cc5607e1c2780c285467ffc7ed9c2fc990db12e8d96b32abc"
    sha256 cellar: :any,                 arm64_linux:   "80288fccea7a08ee549c0a332a049b92de291440b905dea4a7d1251abd730b2e"
    sha256 cellar: :any,                 x86_64_linux:  "de5fe88d34b1e15e80798657677acc59e22f2d39a6a4a263c60fe8a215cffa8e"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--local", "--lua-dir=#{formula_opt_prefix("lua")}"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_foo = testpath/"foo.lua"
    test_foo.write <<~LUA
      local a = 1
      local b = 2
      local c = a + b
    LUA
    assert_match "unused variable \e[0m\e[1mc\e[0m\n\n",
      shell_output("#{bin}/luacheck #{test_foo}", 1)

    test_bar = testpath/"bar.lua"
    test_bar.write <<~LUA
      local a = 1
      print("a is", a)
    LUA
    assert_match "\e[0m\e[0m\e[1m0\e[0m errors in 1 file",
      shell_output("#{bin}/luacheck #{test_bar}")

    assert_match version.to_s, shell_output("#{bin}/luacheck --version")
  end
end
