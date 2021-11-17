class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.40.0.tar.gz"
  sha256 "fe8a7084cf2962b49144971375b7d07f32ba96fca267b5087d03f298ee53d106"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bf4ebbd4dbd76db6ed7040138842d6535a5de89aea885053c4f25c9d11a88fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86172579a777abf3c994ef64f632ce91ae8092e4909463f24cedba74f2242a61"
    sha256 cellar: :any_skip_relocation, monterey:       "a2d84a7c0587adf38c84d07dfbcad3e5bf66ba83378a13d75c282c80cc9bbbb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c749340e4b3c7321b1d3e098863bbcddc1073b57a31dd9292caca9858e1286c"
    sha256 cellar: :any_skip_relocation, catalina:       "f076cd1df378dbde7926f2dbcebb21629e7f345332aa750dd8a84bb017f2728c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e37196124f98e57fbc838de54b6212431554471de9d7636dc310e0a7c10cb16"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
