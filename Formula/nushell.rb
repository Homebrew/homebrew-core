class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.31.0.tar.gz"
  sha256 "4dcbe38b35902a98df3f213fef5f69dcd9870975a18e2a7feb002534e68d848b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90806f916a8a1d9eb93c9214a495b09f795905dfeacfa3c261e107bd61941d85"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f6322077c718f1987751b7cb6c4323346c009ce0322f3faa7ad61d1cb974296"
    sha256 cellar: :any_skip_relocation, catalina:      "e45afdc5b2335c56442fdd8eaf0dec98cd8f131db6c1247bf2e1ce11df4141ce"
    sha256 cellar: :any_skip_relocation, mojave:        "257d5b53f1e037366ecb7caf37489afbe172feb51fa3eb8e709f7b8365f6a1ef"
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
