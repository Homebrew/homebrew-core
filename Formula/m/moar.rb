class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.31.5.tar.gz"
  sha256 "2c03100e24f88163d808d52b7a5763c0fe731b29c46fd44a103a089c5429eb72"
  license "BSD-2-Clause"
  head "https://github.com/walles/moar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c29b3cddfad460bfcb1f1a4e9d9f8f4bad261fa2ca9dbc414ae8a4e27e264cf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c29b3cddfad460bfcb1f1a4e9d9f8f4bad261fa2ca9dbc414ae8a4e27e264cf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c29b3cddfad460bfcb1f1a4e9d9f8f4bad261fa2ca9dbc414ae8a4e27e264cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6990b776f80530fdf07b08e9f36a265c7a82d81554981f00e8b3788a33030fcd"
    sha256 cellar: :any_skip_relocation, ventura:       "6990b776f80530fdf07b08e9f36a265c7a82d81554981f00e8b3788a33030fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7dc8145638ec7ce02822b25a5d2fde61ee74d83c7ab36dff4e69d63daf4ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41de53e9734c1228e96ced53910486a262e7f21da55a2cc9de68dfa382f47b2"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
