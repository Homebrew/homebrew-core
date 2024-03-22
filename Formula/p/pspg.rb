class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.2.tar.gz"
  sha256 "ab9b56c68b50623a9d6ad95232cd7de9069b8374accad27298eff7dbf141c81a"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "454aa2f7012818c29282c607b27a5b8539495b74b080ca4bb611d1dfcea5f115"
    sha256 cellar: :any,                 arm64_ventura:  "9be21d279d36d2c704143ed0efb863173ce0a0814c6aebe12fde30332a2505fb"
    sha256 cellar: :any,                 arm64_monterey: "f7bde4bf3b42571a744dc896578b3e2394a06511721b2224ccbef9a3ccb9261d"
    sha256 cellar: :any,                 sonoma:         "871e455b6ba30eb5ed4b0e889e099c07d3b5608944b2c8a92d75869324ed2df6"
    sha256 cellar: :any,                 ventura:        "7d0ca3d2ee44f0ea6a1700ff6feb5f158b22112c0aeb029e97200358f051fb47"
    sha256 cellar: :any,                 monterey:       "bfbc5b8bc01fd75913dd8307666fbe23cef52b654b64eb91d46576902931bfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489409d4b3403fa51fd604c9f53b378829737c0996a424b64f9432f0fe73e2c5"
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
