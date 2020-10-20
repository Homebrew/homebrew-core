class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.21.0.tar.gz"
  sha256 "24598bcf6e61825fd3b6f17e083952926a4b072efff413748bbd5bc83a3158f1"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url "https://github.com/nushell/nushell/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "6787e969c7c5bf501156a8f10e22b671b8e106327207281c6b322a703f338505" => :catalina
    sha256 "443c9ae3a5090bd379a0b0ba1fe8bc32a645ed89aaed6ad1abf356093e0b272a" => :mojave
    sha256 "a0476a3d69731a438925838e5d41c31e839c5aebc51d0951fc0a6a17f7b32cd1" => :high_sierra
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
