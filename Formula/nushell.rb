class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.29.0.tar.gz"
  sha256 "1572c5e48c7b460e1693eb4dd153902cfff9b5069abd05297b79563e6ffbf9f1"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c915950ff584a2e41f15c579398bd4603bb35ff42154b7153d3fe6927d950d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9ab2940958aa3574fa73e5b81efa021c4fdd68cc770d2e0dabaffa3fc10c5f5"
    sha256 cellar: :any_skip_relocation, catalina:      "5531820e5c83e15223373ec9790229d0e61d1edf34073134222f531e964b096f"
    sha256 cellar: :any_skip_relocation, mojave:        "d80c479e3cb2556a462cc740419849b9eb723b220a7bdcfd40c9d496e6a1434b"
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
