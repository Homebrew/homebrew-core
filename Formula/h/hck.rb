class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "1bfec031e1d5bc34ab32cee4e4185c0277d8e8f29712ec8f2dcdd8347011430b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381ba3c48e2f8bc9b4a5a9907f8be276a6a86ddaee107b4ec259386e503d65b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bcee9989667846d88969d22dfaf486c45a0735f44c32570dc35d33a668b284a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feed8851b11e495cd4280ee3e8b54f57224da7c773f2973ef6dffe09a445e051"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b658750c7456771fc2d2b476958cbe1761fb3aa5220b48a39041f3430ce2e0b"
    sha256 cellar: :any_skip_relocation, ventura:       "c7e690c6a1984d5138cae314b284bfc6e624f3d070e6e318b6170d0bc0f63a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c82b9289300e2ce2b2c134794db7f3edd694d8a3ba51a6961e4245f08c6058"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end
