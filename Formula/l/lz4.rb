class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/refs/tags/v1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.10.0.tar.gz"
  sha256 "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "caf14ac1b6c922611db94615341ed6dc97f5601664280bc1d397e10f62e37222"
    sha256 cellar: :any,                 arm64_sequoia:  "5bd143b7b784989e549637ea4e484af85ba481e640dde69bc35f3843ae25abc6"
    sha256 cellar: :any,                 arm64_sonoma:   "6590245dc4a919c46afa16366914cd4b5c0c4a8f4fb35a4f6ab89053f289ae5d"
    sha256 cellar: :any,                 arm64_ventura:  "03119aa78b7a96d4b8fde7553f5601ff104d59156aca4086a2af7aaec6cba5a4"
    sha256 cellar: :any,                 arm64_monterey: "3ace9946a02899abcc0b8852863a62e70e1eec91deffa579512f0e6c493738a3"
    sha256 cellar: :any,                 tahoe:          "c30d8dad4decfc0f129c4593a304fd2e3fa854058f24310ee9900d6230730e94"
    sha256 cellar: :any,                 sequoia:        "f75cb29a4d25d37e1db38d95c5970cc45de7ec63ce43cfa881a877b424154a42"
    sha256 cellar: :any,                 sonoma:         "96c1ed07b013308a9c205a56c0232e45ae7da70e28200c9adb03ec78b294bffd"
    sha256 cellar: :any,                 ventura:        "c7bd3ba214fd8713268012f5bd71a95dee9623de0e373a38dc3426ea8b9293c3"
    sha256 cellar: :any,                 monterey:       "f78cc448808d04a0c31b108d7da962020e062179e29c7d0a2303db7866d8e449"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e1d4b1bd9069ee0a313d2813d59b3e9217a893aba519707da2ba0b848bc1f727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8082c2e40dc6d63850f43ea8fa095e55adf18fb0f25ec66bcaee2c4b4438205"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    # Prevent dependents from hardcoding Cellar paths.
    inreplace lib/"pkgconfig/liblz4.pc", prefix, opt_prefix
  end

  test do
    input = "testing compression and decompression"
    compressed = pipe_output(bin/"lz4", input)
    refute_empty compressed
    decompressed = pipe_output("#{bin}/lz4 -d", compressed)
    assert_equal decompressed, input
  end
end
