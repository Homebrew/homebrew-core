class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.23.0.tar.gz"
  sha256 "fbb490fa25cb4ca6ec46b33274ee8a222407a1786dd2204f05ceb573eb0246aa"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url "https://github.com/nushell/nushell/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "8ef4ec4eb0a063ad4b18f8d85e0da853bf4ff1959d8625c626fa48e78ca1a9de" => :big_sur
    sha256 "ee05b2e73a5147f6cec8dd144065aab2d02085620e8f8339d0a2ca7329156de0" => :catalina
    sha256 "021e45997127e521d0736734f593a3f318187b352029825d3b4b1fdd59d69cf1" => :mojave
    sha256 "ba1fcf43f7e33be550817233e5208f054d8646cc2ac3c133d4466daec3a5f35a" => :high_sierra
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
