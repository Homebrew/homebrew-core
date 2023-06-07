class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.7.0.tar.gz"
  sha256 "64b1b2e397ef4de81ea20274f98ec418b0fe19b025860e33beaba5494d3b8bd1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d90f186d664613cb2648b8d162bb8939ae4d0402686e4cb3b4af8c849c0ae0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74e62c4583cf8b98f123611e300f717a5105dcb6ba355ae6584acda35ecb2c89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b78500b9b1efc3ab29584d668d900682240ed2a7d709c99701ed688d26d9c13a"
    sha256 cellar: :any_skip_relocation, ventura:        "442324b818b67e8a668166db5a59e2c7a8df7c95e02d5ce8ac2d4465d3561e61"
    sha256 cellar: :any_skip_relocation, monterey:       "fe8f17e650e60a533e372f4f36ac4937283f2bdedc8451232b73cf9bc86fa710"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a7d68183cbef10abb0fed70d25051eee61751ee740b7e8c33beab0b7338a0e"
    sha256 cellar: :any_skip_relocation, catalina:       "e7c2db589c2dbe6340a297ae96dd4a92e4cd1654d4ab0f8a8bd77fd8fd87e583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b627c9ead2e29d59b924b402b92b0f8c2ca43b6c646bb6ad740e680084d160d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
