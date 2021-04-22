class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.6.1.tar.gz"
  sha256 "e46b61636329eca641171175f07048c6baf3c875e9298b4bdb7ada48bdd0c4d6"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3f14a262ed8ad04ba1dbe1e76d5a6bfa7b0504bc42d82f0fa1cc1baeb5af54f2"
    sha256 cellar: :any, big_sur:       "16cdfc51e5444df54006b6402695aa72f5dd8a8af5a76aa3ee4fce0686b03084"
    sha256 cellar: :any, catalina:      "959d4413f51fbd197e03f6d41e53649d721daae531880166f12973361371a056"
    sha256 cellar: :any, mojave:        "742a8eace1e1409076e2bd12869900e1048fe4216b0100da0e1f6eb5c159f12b"
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
