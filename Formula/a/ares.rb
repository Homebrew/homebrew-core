class Ares < Formula
  desc "Automated decoding of encrypted text"
  homepage "https://github.com/bee-san/Ares"
  url "https://github.com/bee-san/Ares/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d951302b572ed0786c366762b430d0d37479be8649b16122548ece1ea0a28900"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6b698cc90e5f474391cb7a574b84ba9a3c9d4e70f4de900676375856a58408a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d2827a8036416c4adba83c9a6fd43eeddf76f6bd7902107ab728cf3369d3d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97a85bf81a02c6a8264a4ea153adc2190d2da0d88920a6f789e38605ffd3cee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2bcc31382c5987f72cc62f942178fd2048d7d4acc71e94b36e15f9e77fc2e8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc8074875bad6f69b3a3caa03a53c42639905b9d755b58d3c9d81519c5c1b49"
    sha256 cellar: :any_skip_relocation, sonoma:         "64ff6858a4170c60665df77f5d3b7ef643a4c91f7e870da9cbfb3599cb196514"
    sha256 cellar: :any_skip_relocation, ventura:        "2ef2937082a01200c25fc1d61f1fdc91029bd443dbc8ee44f0b1b843f8c3adee"
    sha256 cellar: :any_skip_relocation, monterey:       "38bdef4ea6190bb5107cc2f42924b9b5aafcfbf0a7d8b1af0f68088076c58c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "148415168b096df8c5c39e14f6f68727331a3793073a122992e020568d5d87a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8628ee2e4ccb9ff40faedc01fff88f8ab4e7154d3a8573ba4d8b7dc7bb106e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input_string = "U0dWc2JHOGdabkp2YlNCSWIyMWxZbkpsZHc9PQ=="
    expected_text = "Hello from Homebrew"
    assert_includes shell_output("#{bin}/ares -d -t #{input_string}"), expected_text
  end
end
