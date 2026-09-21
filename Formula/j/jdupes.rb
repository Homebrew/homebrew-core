class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.31.2.tar.gz"
  sha256 "a003ba9c57f2fbfc30f5af5a886b12423e0a0eba008429a48506d0c31a807c17"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6971c695f7813826f058f2adc6658a92ee03e53e23839771a7e3e1924193656b"
    sha256 cellar: :any, arm64_tahoe:       "264d71e93a0a3e1ea22093322ab654ffb7232dedae490e873b7d7dd05da1eb5a"
    sha256 cellar: :any, arm64_sequoia:     "f62c55b84332a06d253662b529927e0791692f06820ac379e48e8eb3c7a20fd5"
    sha256 cellar: :any, arm64_sonoma:      "2b364bc664fb82e7a31fe294cfbe9de328ac8b7f362e491597bf2d8d2c0dd67f"
    sha256 cellar: :any, arm64_linux:       "4ad03192f72fd2a0c27c7a5b47b880da451c6276e18a87ec6ef9f8cd7624178a"
    sha256 cellar: :any, x86_64_linux:      "1d99ec4ecc50abc0a82fd2447cb610a971b4782ff190a3917449e33ab0e542e5"
  end

  depends_on "libjodycode"

  def install
    system "make", "ENABLE_DEDUPE=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zero-match .").strip.split("\n").map { |f| File.basename(f) }.sort
    assert_equal ["a", "b"], dupes
  end
end
