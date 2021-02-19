class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.27.1.tar.gz"
  sha256 "bd153a95ea15446bb61a9e0292adc165ee0dd3a586298e77a0041597d68bc04e"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d487b6b9ad1cacafb87155d637d43e408d30bd0385788b7f70e418b816612b7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9d8d601e2adff7f01cb2aff4ec5a5e2cc001ea7e8d22110e5d4824fa21fcf908"
    sha256 cellar: :any_skip_relocation, catalina:      "028b569621cd90e2d992a75cfbca9895b9eaf1b56dbcd6c848ac18323823b56a"
    sha256 cellar: :any_skip_relocation, mojave:        "85045d773521abba3965e8c1747dc4d10ae0e7c1a8a4c968d996c974ca0d4204"
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
