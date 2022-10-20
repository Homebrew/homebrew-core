class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.19.tar.gz"
  sha256 "157b8051aed7f534e5093471e734e7a95e509c577324099c3c81324ed9d0de77"
  license "Zlib"
  head "https://github.com/cc65/cc65.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "9353c4052546b46967c63aabc48e64633164669129e6406f8afc2dcaac17fb89"
    sha256 arm64_big_sur:  "47405e34cd591b17d9ed65842f25ac7c6d9f61e98f21b9c403596257d7e23dae"
    sha256 monterey:       "2598003d7c24868193167d8095f1c4c22a4f46627073e480dbf7c67bba340ce3"
    sha256 big_sur:        "d0010fe7f4b58daea95dd57f4116668bd2bedfbd5392e73412162292034d456d"
    sha256 catalina:       "a773d68d33b81899ebe7c10d294c0d6e2c2eab9063206f787b1e8c5b8e36f437"
    sha256 mojave:         "bd750ae3470b736a6b7260723ead51d6e871edc8d8607f53b670f03c84932a00"
    sha256 x86_64_linux:   "a07773f9ba0bcbe345f8e3c27495b9f149ff0a4df6245748cb8152a75b13880f"
  end

  conflicts_with "grc", because: "both install `grc` binaries"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Library files have been installed to:
        #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert_predicate testpath/"foo", :exist? # binary
  end
end
