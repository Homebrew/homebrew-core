class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.6.0.tar.gz"
  sha256 "b99190e8908d895338c2c3ce90790be3523e0b0b1084c69bcabe5f390fc27845"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bba6dd4a4c9b7895934c03678fd22a567d0cdaf107ff2f37f535b21f9412c005"
    sha256 cellar: :any, big_sur:       "812b3d4b0aecdb672a2e818ece05281d762d59f78363e4e6aedd56ea0ea21562"
    sha256 cellar: :any, catalina:      "a9bbaa1a38181df99fbb2a52f714bbe4d29cc23da2b8077dc422ebc589e2b78e"
    sha256 cellar: :any, mojave:        "57afb41d6f6c5eb0185c1cc720035283c6ecd25cfa91f9c4d9595a032324f12a"
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
