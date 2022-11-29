class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.6.0.tar.gz"
  sha256 "bbfef119462633ff8effd2a2146047897a356f9a194fecc09181085ef7ceb5d7"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efd3a9c7fe36dab943e27232fb564dfeb1648c6c2a2eef5fff851e3ecba10d78"
    sha256 cellar: :any,                 arm64_monterey: "16d29a0ca9017030972f8129a117d5ee0fcfbd77a8192ffc19732c5f45af4163"
    sha256 cellar: :any,                 arm64_big_sur:  "5549e87f41c29bb9fd81c454f1b42ad5522e4efd4057ff917c18b3c3e272d9cb"
    sha256 cellar: :any,                 ventura:        "54985759b7f95202596f2b2704883d6fab11ddbff0c1b7e6625923a613e9d7bc"
    sha256 cellar: :any,                 monterey:       "aa12ad9d2b5c6221acf3d2786ee91145212e99f92405d95cfcf5fb7954b25f2b"
    sha256 cellar: :any,                 big_sur:        "fbdd46de96808d4bf235926dfe16dc3a951fbdf9fcbb955ce9f3699cc41784a1"
    sha256 cellar: :any,                 catalina:       "905ca9b3dde143ebb6f8aae53c6feab6df37136fa94df17d0f8db83c8552a29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda8c37aa5d7e2316f66965731bf49c3058e28390de4eb0a581a30aff0d65a2b"
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
