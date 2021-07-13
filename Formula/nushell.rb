class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.34.0.tar.gz"
  sha256 "9571c7fbf0f0fdabb055727b63b6a5c3561f04357336289106591fc6afcff7a3"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32b6f5f5876a6300350837a82de65d4955252b8d25071b97fe10cc5c4f4018a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "7284250388ab1d340a6700b5c98d342c3234e06c138308b4f4f9929bfea3fd27"
    sha256 cellar: :any_skip_relocation, catalina:      "68b5edcf15ca021fc19de8d4dcc7bccbcc24ad23cc3279b5b7d981a20f0c132d"
    sha256 cellar: :any_skip_relocation, mojave:        "82712d1fe54a439313dd3852b11be5fae7d824a7500bdced32c596137eec5cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7531305cc27ccbcd887d770c75dbd2dbebf22fc8cc9d48584ef064bac2c6b710"
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
