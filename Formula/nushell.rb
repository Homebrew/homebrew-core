class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.35.0.tar.gz"
  sha256 "2e93366a2f089bdbe0ae52eafcda5390119642c66e541b26e8eeb1ab4bc13823"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdcbd8b8941fe2994151606257fd1fd7b7f00e73cf72b2ba165b8bdba9151cb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "713c46654244054e060d2870b1396b47918b1eea1c75093194e19ad04a1a0832"
    sha256 cellar: :any_skip_relocation, catalina:      "9978b53fb975e39052f20f06ba17fefc943272835d18c0dafa43d98b7ff22f53"
    sha256 cellar: :any_skip_relocation, mojave:        "595918d6976db050b9c6f786b1d1f74cd55a0400eb40e6dbf3872f7fac25d56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a82fca5387984eca3a6e4e0575719b47507d3b396a1770ca1d641d6999bfd00"
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
