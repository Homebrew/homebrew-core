class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "0b1d9f35674b6261225f51f891d2b8bd2ea80fdddb74b8f43fbc56106b6dd054"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af3779931e7b6aad74e36a73cb486353ff790ae95d8a4cadc3ef37126e827aca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af3779931e7b6aad74e36a73cb486353ff790ae95d8a4cadc3ef37126e827aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3779931e7b6aad74e36a73cb486353ff790ae95d8a4cadc3ef37126e827aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78e3cac7509b689e985bcc4b37564ae26f9519bf69bbc3f258019c4102658d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8d9c9cb22ca952966f9bc463571241200d5a9093c1939b3df359f06a580f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6bf965718452a850bc3839b91a55234d1db8b7eb5a56e3483623ce14bad091"
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
