class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.26.0.tar.gz"
  sha256 "66fbfe1297997a3f6b2181cd723816150ad2453527c7cab6c83a9c67b9af2478"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72434b0bd7d06c865e49c70e523b5a2caabf1fee7207a71eee248e32803fe7a3" => :big_sur
    sha256 "b384174752cf334c56eaf4359f423ab7ad40c9945465851cc66a8ae5b7d63d44" => :arm64_big_sur
    sha256 "e75e7e0494ebe1157797213aaa6b1a2bb33f7da507601537dd19f81c83a97fa5" => :catalina
    sha256 "eb00ba8dec78c540d2fae052e746b26664cc27eced6affc46dec069ef5cc33fc" => :mojave
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
