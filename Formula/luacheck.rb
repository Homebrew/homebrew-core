class Luacheck < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cd2fb0f54d7b597a64526c052108c7f3fd9ee894bd71afec9851c3253a247864"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ba5636ef76bbeecc3cd27ec5947f4627501dc738d344fcf41dd89bceeb226b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc98e9b4317978385343cf3185829d0d15f9f2cef0c0085ac01754bdd84a3bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f67c15c64868e620a5edc5f4e1f7d61d0d1df5be49e92ec9cb0c9881c3464cf5"
    sha256 cellar: :any_skip_relocation, ventura:        "68a42e4a006623c4897cba39c758128b0efaf892f8530fd8f30241604bd36f16"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3b0a98a2a65e8db03c382d64e9961776eb053442500e3688a5a9d4d81664d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb48083328fdd7a3556dd3b12ce0b4ea1fa90442b12517650c22a9a32e5e339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6372ea278050cbb360766dde7c361012a8a84bede7ce973b365b27cfa8359033"
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
