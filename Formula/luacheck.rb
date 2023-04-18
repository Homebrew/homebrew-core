class Luacheck < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cd2fb0f54d7b597a64526c052108c7f3fd9ee894bd71afec9851c3253a247864"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c52eec8ce22ae6d0a9c352e8cc2acf63ca064f8e3e4cb4b28517df3750486b48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85858a27b1932883df2464498dc6fa79ced38463a1f6e9aef1a0224678c3e2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7d59b21c1f2befa820d5a99d5b6d18663a17752e764bcbf80883ed7b88b1d58"
    sha256 cellar: :any_skip_relocation, ventura:        "42377d496ffb2a90e4971474b3226a8b53a0cbcb336a5c8c639267b8578c5505"
    sha256 cellar: :any_skip_relocation, monterey:       "4eb6f5b98fa4d439ae11c286428ec9e59e0c23b07086542eb814d1858d655cff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c53242fb4fd42f477ea332f977bdf075d7c38f645fb3fac193dd4cadb508455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2919182c6d6acaf942189d571c2e478279d6795924467eda8876b96053bac352"
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
