class Luacheck < Formula
  desc "Tool for linting and static analysis of Lua code"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "a3ae089f3939b9fba4dd91c8c6f206e088cc4b21b49f1b6c7a5cc7345a09dc19"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c96fa4a0daef81ca905bb59f523a13ac979fdd226ef673380f3fd39856e9203"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de17c1971b8c16c61a98157320e57e0056065c9deaba3dec6a5d6a87a1f6c832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23dbc638f15505467c476d4d1a5150a647a4a23fd77979951bc47fd860aa41d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0027715fc55ede184ae4cc5ca132a79d7ee8f01cbcd9bb3966c863afc3ec2d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5aaf00c4d0f17bc5fb0b1bbbabaea0d5891f5798307b35821a625f90512d69"
    sha256 cellar: :any_skip_relocation, monterey:       "f770224bfcbf6fff0569370be5cc37adda4738e7756f26667be5b8b219afa1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de5748f2be12e02d00ae5757eee046f96041880982153e79e681be5bccde5fc"
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
