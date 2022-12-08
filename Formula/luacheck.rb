class Luacheck < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "360586c7b51aa1f368e6f14c9697a576cf902d55d44ef0bd0cd4b082b10700a8"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

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
