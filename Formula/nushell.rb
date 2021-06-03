class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.32.0.tar.gz"
  sha256 "57cbd6cbbc9a3d2f8b99942486410e003487be0faabd275e87ab77342a8c0989"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0e6d3a67874b9fca956aefc2ddd215e838dae68e6e0c659ead2f4c6f0860d07"
    sha256 cellar: :any_skip_relocation, big_sur:       "17a6322d9a11f14c3400c9aefdd88d36680978c480bcdf2f638a3067ce2c9bd7"
    sha256 cellar: :any_skip_relocation, catalina:      "8876920dea799059cf71dece8b89a2efb3864df6a91a63033d9b34eee17175e2"
    sha256 cellar: :any_skip_relocation, mojave:        "d053109a916c21687ab431b852cd08fa15dd244cb3b166e7008578fb5afac19e"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
