class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.5.tar.gz"
  sha256 "754d1e380d072517e9bc2c3c38785e2f19a9f927f061de9a646fd1094baa204e"
  head "https://github.com/okbob/pspg.git"

  depends_on "ncurses"

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
    assert_match("pspg-#{version}", shell_output("#{bin}/pspg --version").chomp)
  end
end
