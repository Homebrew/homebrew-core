class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.0.1.tar.gz"
  sha256 "b1133abcb34740612c6b533eb4c31ca90ae6c5c2f9abda53b1b1554b935cbe49"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "dad1cc71a6b4df146f669a8b6c2b8bd0c82edf6b9418fe9693e7a299e35befa5" => :big_sur
    sha256 "df9e4e1d041674e9ca336de18370cb8ae2a8bfa668033f2625a1a4688cdd6ae0" => :arm64_big_sur
    sha256 "030e7d79f91484e0d42906f3c91a4ec7b989dfd1b3a29d868ab016aa1d7652ba" => :catalina
    sha256 "3eb4d388a5fe78d7d7c5c2f7040fc9e12bb1d0ec98cd2965e85b275d360f934e" => :mojave
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
