class Luacheck < Formula
  desc "Tool for linting and static analysis of Lua code"
  homepage "https://luacheck.readthedocs.io/"
  url "https://github.com/lunarmodules/luacheck/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8efe62a7da4fdb32c0c22ec1f7c9306cbc397d7d40493c29988221a059636e25"
  license "MIT"
  head "https://github.com/lunarmodules/luacheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ea7866d9c3670a0b6536b69160e26c89b0a978080d7a6ece965dec75041c9afe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a169aee2121f7c2ed0b06c929b7d7af23ffc3307bdbf0422d55320eb28c4ada7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15a92f15305c2dd68712f301650a1e4dd44f125d877cce6805fe7c350a3d6846"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afb2f3120e5fe5f65c04b23fb0b0c71b11aae1f568b0ee089ff571aa8f646760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e14232fc83825fc5e95905a1494ff3871ea0b714304a1bbdd1341aa9a23e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c001a53a3e07a42f1feb1e8357d10413acabfb687b3b91aebd5f04e576c1332"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8e782aac328d196dab06ac9da394d11d8c613c9057ef7392abdb44e3839e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "94a98b05bfa94bb3ec210d38328b18028f764bd1024efe56c738dd8b9c481e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f911cc67b563f4f04f2cb3239c05dda795bc53542a2dfa2d4667d35b39aeda8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaba85e939f4055b051482af96f2009a1a86fc113f69b12abc4d6a10ec887e64"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--local", "--lua-dir=#{Formula["lua"].opt_prefix}"
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
