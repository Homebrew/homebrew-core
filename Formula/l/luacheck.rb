class Luacheck < Formula
  desc "Tool for linting and static analysis of Lua code"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8efe62a7da4fdb32c0c22ec1f7c9306cbc397d7d40493c29988221a059636e25"
  license "MIT"
  revision 1
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e93fc65e7bb98c16badb77b3522aed6a606f0f125b7f2099c0c584560e14404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545ef824db8e8864f4ba49156123f66db29b9ec37db0c95c5b2424b099259587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d271724f596f98e71be5bd4c9d311117d2082fe5eae3ba2f9f7e20e2a29721"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76cf3029832d0264fd142ac4abaf34db5138f7e06ac3f43f00a16a0f6c78967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ef7a9c5ca645b8a28717296653c402520acb73ef9fbd3af40d84dbb7bc2d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b3ca9857d49e8b51863bc47d95e58b6ed801e46880375c539160e0bfb2af2f"
  end

  depends_on "luarocks" => :build
  # Blockers for Lua 5.5:
  # https://github.com/lunarmodules/luacheck/pull/136
  # https://github.com/lunarmodules/luacheck/issues/134
  # https://github.com/luarocks/argparse/commit/7c71eb8ce6f75b57c35181c39f93738d67a862fe
  depends_on "lua@5.4"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--local", "--lua-dir=#{Formula["lua@5.4"].opt_prefix}"
    bin.install_symlink libexec.glob("bin/*")
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
