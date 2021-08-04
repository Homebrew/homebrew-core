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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "965ebadcc5de5a7f53af41e1cd1418f0ce622ea5ac282a8c296fed55ec56f808"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3aed74e0bbbc23c2365cd18e494197c630f0e38187317e6945b097a609eb171"
    sha256 cellar: :any_skip_relocation, catalina:      "26bc771ea9988043f2dba78a71b7bb03bb3f3692f2d8acf0a4d3cc8224477bd6"
    sha256 cellar: :any_skip_relocation, mojave:        "5db104a1f62775558485ed29b0d3c0221d1d4960b2937818cb2949c6fe263575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0982974143dfa57b85ce7a656b63496cfa103a766f35a7bdbf6abc7a70cf51a"
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
