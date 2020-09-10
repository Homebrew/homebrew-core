class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.19.0.tar.gz"
  sha256 "18aefc280a51b2202daca4c5c27aa166f5c0049ebef16d9206fdd88616e8b2a0"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  bottle do
    cellar :any
    sha256 "49511da84622a111286b1e7b65df8d3294115783827424396cebe157f55a07ba" => :catalina
    sha256 "c37e14e2354f1c4179140739e00006a492d40c82b0fd7fd269ad3180382e7070" => :mojave
    sha256 "1987098d0bc2539d351471e080cfc9857b32b05b4598913b5328dc15ec038531" => :high_sierra
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
