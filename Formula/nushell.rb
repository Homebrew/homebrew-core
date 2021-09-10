class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.36.0.tar.gz"
  sha256 "64700fd9a8ff3d453a8c0b0831e5536cb5f12fed55db2fce29c12c09dce9f314"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2790bfaef0ff9fb0550d291f8e814da3e057688b8f66bf4ffc8bac318799a8d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6cb8f8d2a28c28f8775f7ce6e8ae9c2056360242925731de4b125045dfc7e6b"
    sha256 cellar: :any_skip_relocation, catalina:      "e88a27fee1e49b1433a63b3ecb6406f05aed6f7d00cc73cc368ef5ea270121a8"
    sha256 cellar: :any_skip_relocation, mojave:        "2fbf6c8e829ca8cab175170d4d2d74049c76e91282aa339f5b349d0a785e46ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c1263945d2b509488f7a0b026ef392fe9fb0477e97dfb2bc32b7274dd5a4be"
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
