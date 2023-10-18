class Luacheck < Formula
  desc "Tool for linting and static analysis of Lua code"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6ef4276498c4bb4ec527c3f942e35ff5c71fdd8c88ed0619a83a1c967d135c81"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3df280acd7599498b6725a39e37789436688884941259e415b61a3e784da7436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6e0ed26ec229c27e88566004cd49d9f6b21d17e356d3e0acc8ce74324d842d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f62002bd4aed8cf19a0f1f1a46211bc0ffe0e589c8b7db53abcb10a8415594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3998530e4c43b096971256853c6fb48e42ed5ae94f7c4fd1cbe3d58e5bc2699d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d58656cb34f854f31006b703eed163bcaea5a90745dca12e691d83784fa9061f"
    sha256 cellar: :any_skip_relocation, ventura:        "349998dddeb7ab02db71faf48239245f0462b40ef0f0d2f17abc6b11e246635f"
    sha256 cellar: :any_skip_relocation, monterey:       "327ee4e07efa6495183e462554ba02973caa0669d0f718b121f718bf65223d82"
    sha256 cellar: :any_skip_relocation, big_sur:        "3837335c3e9bf8cfd33c2d3d4572b35385b0a7191a9240a6a7ad365bf9e54163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc597af58be9d43cfdbfedce8dc3f7bdc205d6365550e45f6653de00546e84b8"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--global", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_foo = testpath/"foo.lua"
    test_foo.write <<~EOS
      local a = 1
      local b = 2
      local c = a + b
    EOS
    assert_match "unused variable \e[0m\e[1mc\e[0m\n\n",
      shell_output("#{bin}/luacheck #{test_foo}", 1)

    test_bar = testpath/"bar.lua"
    test_bar.write <<~EOS
      local a = 1
      print("a is", a)
    EOS
    assert_match "\e[0m\e[0m\e[1m0\e[0m errors in 1 file",
      shell_output("#{bin}/luacheck #{test_bar}")

    assert_match version.to_s, shell_output("#{bin}/luacheck --version")
  end
end
