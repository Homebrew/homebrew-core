class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.0.1.tar.gz"
  sha256 "b1133abcb34740612c6b533eb4c31ca90ae6c5c2f9abda53b1b1554b935cbe49"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "58952542b64a852bfdeddeefc32b2810ada388eb78dd43cbf9161c3b718870c8" => :big_sur
    sha256 "76ef6ee75897bdcd734ed87b0a2a5e57a9440a779af5a254c9a167a60ad860a9" => :arm64_big_sur
    sha256 "b966c5a0253318767c9a2f28f37ef7fa368b73880d2167dd560405846f7d63d9" => :catalina
    sha256 "411b56b0e0945c0fa5500ff0454c1109193e5df5a25f87b3b192b5b1607a4c8f" => :mojave
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
