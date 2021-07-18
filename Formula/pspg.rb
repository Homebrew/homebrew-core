class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.1.1.tar.gz"
  sha256 "46bef6cdae6eb056d79b9fac6ece1134730834b2efb49665270121604b8403dd"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "98699c7907fdc5538fc1f219455931377584dbbf2083b0b1d6418e28ead1ebd2"
    sha256 cellar: :any,                 big_sur:       "cd253836c86476bf07bd12c96326e7b4aef72ea53523ac68212c6f4ccd0f91b8"
    sha256 cellar: :any,                 catalina:      "4fc02ff3b704996e389d56dac0bb141f014ad644379ff1479ae3dec167ef621a"
    sha256 cellar: :any,                 mojave:        "72abd00c24036f3ca6e5434ee8c4f4980e81b88ea0aef62e391d7e3f7e01fc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190592f954517a2f6c319ca0331e09e70cdc3f53b03ea2901a32ef0f7b4c8109"
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
