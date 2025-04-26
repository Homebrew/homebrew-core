class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.9.tar.gz"
  sha256 "c84c4d2cc14bdc3780494b77cf31946549e59e501555e0b0b88747181d4ec087"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7076a02292216e37eaec44a23e6b28f2067f10bca0028fafc3c2ed6dc5c34d57"
    sha256 cellar: :any,                 arm64_sonoma:  "c29e8ef300a6562a0f63bcea2fb374361b5984d894fe9869a90d7a4bac05c1da"
    sha256 cellar: :any,                 arm64_ventura: "b2762891a1770204ad92562e49d57967403fd778d9bce2bd5266c5b5a15cfed8"
    sha256 cellar: :any,                 sonoma:        "8dd436463637ab1fefe50d66fa022b570380739ee998c27035bfa5391798bebf"
    sha256 cellar: :any,                 ventura:       "3d60eef5d89dd695d8e5e788a3ac164e139a76fcbda51fa6497d3297eae1e219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a31b06634de9b9a85a805befcf6e5d5fad7161676506f40e2e709db0a4e0dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d40bcf5006f68a1c22305029267f3b6370334f552958aa7e4812eccfb67c973"
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
