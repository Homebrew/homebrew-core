class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.2.1.tar.gz"
  sha256 "e62c0639614fe2bc57f94286a607013e1b8c5846c00376dd9dde697bb94ce4da"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "69a0759672e3ae3f8135b9977161e328d20279127731047a65e76363b613b2d5"
    sha256 cellar: :any, big_sur:       "8619637aa0b45281cef890591e6c4ec9ef5d7d07745b2e8ad5898bacc2d694dd"
    sha256 cellar: :any, catalina:      "956e14eee310ad0c1f8a2ce42b27421aae9f3989f9b0815ec7485efb9b43de24"
    sha256 cellar: :any, mojave:        "b7767e3f054468e332614f0dad832d7e76f7c102843dee97e68ec6b5c8543fd3"
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
