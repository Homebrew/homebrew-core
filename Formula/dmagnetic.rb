class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.32.tar.bz2"
  sha256 "9671b863cbb126e122923fa974806ff0e998af471c98e878c1392c20a3606206"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8780abff0b126cca9e22f89a1e84c6cb9187c5638743764329b84df8063098a"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd532ceab76672bdbcb72e04c88eda4095c60f1c14bea92ca44055a175e886da"
    sha256 cellar: :any_skip_relocation, catalina:      "785b5fdcba51200e389341550837690f9796139e50770831d8d08a36a2acfafb"
    sha256 cellar: :any_skip_relocation, mojave:        "31873834919bd8ddd75ce8c608f8866894c369c1bcc1fa46e4778bb6531199ba"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
                   "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
                   "-mag #{share}/games/dMagnetic/minitest.mag "\
                   "-gfx #{share}/games/dMagnetic/minitest.gfx "\
                   "| md5").strip
  end
end
