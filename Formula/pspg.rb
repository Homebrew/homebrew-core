class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.2.tar.gz"
  sha256 "6209732de97a843e9c0a1de99307927fa54203d19e0b9be4dbebc63449090ea9"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "3b81d00a608cbf4ff982a1d51f43d07c96bc0029e137a1156fcaeb9b2470d93b" => :catalina
    sha256 "688833633c283530500313a0359a934426c8af130be40e6d15f5a7c01216a54a" => :mojave
    sha256 "3fd5c0598c3ac0332388faef921c93caf8ad11968420b34a3f0f6dce4632f5d7" => :high_sierra
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
