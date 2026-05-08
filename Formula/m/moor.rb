class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "d04452c333c5472d22421550a7fca0e17b55e35b301d2d5112c7a4f03694a1ab"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d2d601d12e6240be07499e666c3ce39df09e82e079aa24cb55a293d9dd01f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d2d601d12e6240be07499e666c3ce39df09e82e079aa24cb55a293d9dd01f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2d601d12e6240be07499e666c3ce39df09e82e079aa24cb55a293d9dd01f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9609556303e9b3cec1f41e5b8c44f5780993b6f889508266d6492c0334bab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61832b085718deb5999f3551e20f359326b4832318203471cd9a42aa712dfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0fd459bb691693a7736e1bd53670cc9705927eb71733b6875d145a0cb09fbdf"
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
