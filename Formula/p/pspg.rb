class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.7.tar.gz"
  sha256 "cbbd13898f321aab645569e32808dc3aa4c9529ea008b321f21e7a0d8360fcc9"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91e591a7e3deabadd0becd5f5522c9b0f15cf6214f282288811bea9d8e06d65a"
    sha256 cellar: :any,                 arm64_sonoma:  "ad76c3913603e6a17a719184c2b90ea8ee2db75a9fead0e91dc0c8e9d45fee0e"
    sha256 cellar: :any,                 arm64_ventura: "1e6c8ade2eb3e649932a00d7d8ec6b76d5fa489d9e8217d533591296697c28e6"
    sha256 cellar: :any,                 sonoma:        "a2239df4da9ef8ac0925e855799272e97e275a083681b6bf3bdc76a581140db3"
    sha256 cellar: :any,                 ventura:       "62b53d2715ff936544d6d3553c22680b339143ddd7d483b89ec0436d2b3e7843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7ace57d851b23431b34d1680c6210e52cdda49bb2003411dab730321c2870a"
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
