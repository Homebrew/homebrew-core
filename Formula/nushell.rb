class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.28.0.tar.gz"
  sha256 "aa6769f614a031ad33738064030d1c0d9ab500b2b0924adca71edacb1bd1d85d"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d38d0e3f559f665fd410807254434fadbf295f5d96ba99583be150a3a4d870e"
    sha256 cellar: :any_skip_relocation, big_sur:       "55c00db0d812dbbcc02f92af13888c0b73030a72ec59efd38189a47df404bad5"
    sha256 cellar: :any_skip_relocation, catalina:      "45aa3f866e7a5e04d601c351377149a1579a8d41abcbd6651b4a417aa1eec776"
    sha256 cellar: :any_skip_relocation, mojave:        "cb0bcff75b392d5d9add7ef5e9610e87d2ca7f4686a6f129f3e8f0964cab5178"
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
