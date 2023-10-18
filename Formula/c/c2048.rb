class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c.git",
      revision: "6c04517bb59c28f3831585da338f021bc2ea86d6"
  version "0.20221023"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  livecheck do
    skip "No version information available"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbd85875750479ff4df41f6b5ebce81f6f101296205a96a64bdf5b861101a8f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af09eafcc4fd021eef5b7bc18729b9b8f7725b423a96d2153aa080d43697c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ccf5d51d2560db0b2cadecf2eb3cf592ac308d145e5080a3531170bbcfd0ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27fdf42e2a3b88483aea832a6e3cc61b4e0d4f4382285f695c8d279ae1305244"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5629b4995bcaf832a4c00fbd211409a99633351cc738cfeb34e8fa0e99444bb"
    sha256 cellar: :any_skip_relocation, ventura:        "c7fc6c6eca0664eade0ff2eb4c687fe7c3e626b37022d7bcc3471da39d29c8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "1558d9e5056c2db21b8420f3eb848d3cfc2367d487c02ca10d5c57e66e4bf20b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d17ded095ef158f4794448daa9f27803d9466dcdda8db71d42c3ba22c44302f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623747462419238298b5585273d4cfa738d1a7d36b9be89473faa49c1bfb0c82"
  end

  def install
    system "make"
    bin.install "2048"
  end

  def caveats
    <<~EOS
      The game supports different color schemes.
      For the black-to white:
        2048 blackwhite
      For the blue-to-red:
        2048 bluered
    EOS
  end

  test do
    system "#{bin}/2048", "test"
  end
end
