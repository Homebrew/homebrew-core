class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.0.3.tar.gz"
  sha256 "18003b2fbbbd8e4d0c19826aa180c8e432a2fed391a398d4a8ae4f118d4b3010"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d391b0485dc0c5582db3ced5bd90065954702fbd988cf1eacc23aa4256e5ac8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa0ff560a9aece7c3bfb0fcf8485fcb0bc86828fffb5a3d691c15d8a9c2b37e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5f9361193dbcc7746a1002fc14d02ef0e711ab0d99add8d44192816a6ecbc7"
    sha256 cellar: :any_skip_relocation, ventura:        "a59125dedaf2f2196dac167c6e7d43fe75ca60f7bf5323328d691f1470fef01f"
    sha256 cellar: :any_skip_relocation, monterey:       "86e28d56050e9d1b7d59d9b0f29fb4c85f8c01bc97fc8be391c949d8a16cc18c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6115edb2736e0073aab404d03b9ce43b82a7072c771cca43b3fe3796a2eda155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fef4e7452adfba54c1702e6cc20715e5b6aac68f12206a55b1d432fd7cc243"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
