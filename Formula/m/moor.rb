class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "807c36867ea07878143236ed1bd2053aba1064529401b730639be4d028dc7648"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c62cd6ed85e46fe96884a47d62699d1b16b4003bc25c46380514251791b56ec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c62cd6ed85e46fe96884a47d62699d1b16b4003bc25c46380514251791b56ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62cd6ed85e46fe96884a47d62699d1b16b4003bc25c46380514251791b56ec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d6144f4c17e772202878149d742570121b133f2f434ea113794c8c0a0dc36f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb7fd39e9b64afab64231e71ce866989b974f2bc8e8d7c00781d0bb3eb984b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e31d4dd2c91129114dd7a90378082631361474805c9368c06afc761c7efdfb"
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
