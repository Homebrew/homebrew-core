class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "efef9649f11aae825423381513a44b28840a009bf928edd436068cab0fdb5551"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93128bf74dc618e297d6a889ead2435214355e0260aab156fe7e0be8d2c0ae1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93128bf74dc618e297d6a889ead2435214355e0260aab156fe7e0be8d2c0ae1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93128bf74dc618e297d6a889ead2435214355e0260aab156fe7e0be8d2c0ae1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6688ef634b33ea82baccfaa8cea4c3faf6a184bd47d994213eef79901c5983a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f44e194906e34792c86b908ec761a15253fbb5eb80fa1da5da038848c3ce54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732b511951fcfc078d59af2c69dcc6e51b1d0bb31aa406507bce6a5765ba9e53"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
