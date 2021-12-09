class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.41.0.tar.gz"
  sha256 "5730be0ed50069cdc5981097af086592f06a4e5cd1d02bd0ea10fc1860881695"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3671e7a7fe7d4e53294d36f35380ff23ed505e061186b5634ac4c8386e0d6f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "562afaa9cdb1336689da6ac4e101d9fadac5c86cf7cd0d0af57a94bf66362de5"
    sha256 cellar: :any_skip_relocation, monterey:       "500a977c3367ffad34fc486788df066549984369cc16c033442b5c255fd17445"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ecd0b3615c607f68402906e7d1dc154793ccbd18d4abd34237d9e5d4fce167"
    sha256 cellar: :any_skip_relocation, catalina:       "b45099f5d152f765d21f6b72d7deb2fdfcbf19026c2111946ff78b499a0494a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e03dd305456fee0639b41df94a21aa6930ba8c36c328696a00f120b999643a"
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
