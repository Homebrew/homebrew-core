class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.4.0.tar.gz"
  sha256 "6f91324851d9eab1da8d1d4661be386af3d8531ee00df0243c7d9b03361fd445"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a2dea10ba149f29c27746499dc0fdbe65989a99f7312cad0f395a974c859b108"
    sha256 cellar: :any,                 big_sur:       "798352b9d29aae0ab0df105a505f741499d40a23eab0f04940d0a667e6bddefb"
    sha256 cellar: :any,                 catalina:      "3738a9c64dbfbc2ce4c3f297a18569a08f10da663d8236da97942686eeaeccd1"
    sha256 cellar: :any,                 mojave:        "6540f373e4eb0fb544c49878f78fa3a4485e00f0ab5907215ffe53b94fd1b23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb8b3863124e1fffc1d8a8037fe62ffd1105e750dd826816448b4f4148cf288"
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
