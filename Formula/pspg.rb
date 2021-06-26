class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.5.tar.gz"
  sha256 "0bafcddf47d880995b4d53d9159e201c8943317e3a565dc6d35ca478a9714f35"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3ce57e67872692fe92d59b4e9d2b682e836de9afc49c1910b47f8a04f47f334"
    sha256 cellar: :any, big_sur:       "5620e4810b391f14d9f993e7541b8b2db7bb3a7ba97bb0f83fcd3bc34467e763"
    sha256 cellar: :any, catalina:      "a331e3fc96a16b616ddacd745e2a64f6195ac51cdce860645729c86d5827b028"
    sha256 cellar: :any, mojave:        "4534cec92c8c7310888040cb5965f4d2cc7dc588453fa1545eea3fed9b87be43"
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
