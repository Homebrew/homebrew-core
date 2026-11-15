class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://codeberg.org/jbruchon/jdupes"
  url "https://codeberg.org/jbruchon/jdupes/archive/v1.31.3.tar.gz"
  sha256 "3f76188082330cc28d37788377f0ed06b0ba181fcd4d88827a59f26a0c396168"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3048cdc63f13dafc51f407cdc8eafedd2d7a70eb6591cc765298d1f0f379075d"
    sha256 cellar: :any, arm64_tahoe:       "224f99a6efe8e3db3fc7fedbaa6646c30ccc24240d054297b82888ec410dd726"
    sha256 cellar: :any, arm64_sequoia:     "0427f4884054560d0958f9ea4abd22dade5d9b1fe7601ae16788f4858af2edc3"
    sha256 cellar: :any, arm64_linux:       "1f5369b13627c497d5696fefe2966a6caaa15a53889845f7dc1ec01fb6a1c3f8"
    sha256 cellar: :any, x86_64_linux:      "54ef7bcac0cee88adc94bda4a2de0b773c9e2b550e876cd78851911f9e1b6edd"
  end

  depends_on "libjodycode"

  deny_network_access!

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
