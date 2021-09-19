class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.37.0.tar.gz"
  sha256 "1e8f36a4825e52b28993eec1c63d878f426ee8f091942d6bfc17e60546d5959b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "472b5b5c40ddec42f55bbf14ce27d29e9be61d040ee43543d49dbd47d6d89228"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea6c80627c20886195fc0014dbd388cde2ec648f3da13d11793b8789a735bdf5"
    sha256 cellar: :any_skip_relocation, catalina:      "ee37d831cf36ff8a4e9e547b068dd2b086c0e4a8113775fc5fe4ff55df013d1d"
    sha256 cellar: :any_skip_relocation, mojave:        "f18c654e9e2348c54e449267d74d22c134aeb98bb8b69f6d0c1a3d730e2bdbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4ae9a002861a2de522dbfb0846c397d8ffbc404b5bad29319b6cb59ab4279d"
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
