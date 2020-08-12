class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.18.1.tar.gz"
  sha256 "68761a9145630199df16ccb39225acd58c19c8773aaa79ab5eb1674ff694ca79"
  license "MIT"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ddc25f761961433af26fd2fae2ce1e62313c83f963b3a1336364fd6740f63f1" => :catalina
    sha256 "15e98d6a0d37f3ceb3997ae2881bd6195b764f98efbcaddee6805437066a55dd" => :mojave
    sha256 "6ca2256eff4dbc529559bc8bb5ef0f1f2db9632f776e91f3a5d1ada096c5501c" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "stable", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
