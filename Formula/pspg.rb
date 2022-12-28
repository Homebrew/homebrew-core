class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.1.tar.gz"
  sha256 "27f170e52be0e2bee0304feccabeb2c31863a2bce051766c240a0cd5909afe1f"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b34128073371c5e4b892b2730addc890c447d5f9bd418eea7abfa95311db2b23"
    sha256 cellar: :any,                 arm64_monterey: "b58f45a7dfa37f14f9771364b187a0810237a79baf4a9c949b739955058e5c3a"
    sha256 cellar: :any,                 arm64_big_sur:  "0b5197cd627efc1a55972c83b899f343e169e00a0ac6782b3bad2f53c0255f73"
    sha256 cellar: :any,                 ventura:        "a55274f1ccdfd6b5fd0bcc54da2f7dd6a6695d5a665c65074aba721188b24719"
    sha256 cellar: :any,                 monterey:       "998039dfe106f355ad681b3e233a223776add28f7ad44ac6f06cbe9d975cc98d"
    sha256 cellar: :any,                 big_sur:        "6d59d1af62a670b03d0f6663026ee95fecf99ad487df05747c11f110b1683df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e4f3fcb9d35ab1f1709ff1bc89a1416264a475ccc171d2960c1e375875c426"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
