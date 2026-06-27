class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "397e997125ba7ca87893ead100384b9d4f0c97bbc37405009c791ec69a93febb"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ed01d7409f38346036169f1bdc4712f5f7cdeac3ea5b6418571df9431a9d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b01ab0296d58105b91302a3432ca76689efe6288b67dfc57faa5d29f8ef153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e055782ea2fdcabc09058105aeb6bdc573c37ef7ebf0e521c46f79e5d612a96"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4a84c0d4be4b28925f79c9e18aaeda0729d4eeac75cf1e3f8df84129babec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0500e202d684ff46ee876924101c0ed7bded9c8b98392afb67d59090df3e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55750f621384c95c077d74a3c739b7db018aec4d864d2febcc126c14aa6a4afc"
  end

  depends_on "rust" => :build

  conflicts_with "evil-helix", because: "both install `hx` binaries"
  conflicts_with "helix", because: "both install `hx` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
