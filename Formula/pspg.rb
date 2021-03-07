class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.3.1.tar.gz"
  sha256 "58e166163683f205601997fd6d7aefeff46835b79ca1f62a75aa1fb218ac8cbe"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7ef38b71f2d4a73dc86d66fd4e99db34c88118ab07243046865ccb411d759736"
    sha256 cellar: :any, big_sur:       "4e858d9d3af1a994fc6c0f8b3ef7269abdea46a2dda1f10f68019af33d2c4b28"
    sha256 cellar: :any, catalina:      "fe079f4db2545eefd0e3ad723acd352bbc0626e13fb975cc5f7e7bcf561e54af"
    sha256 cellar: :any, mojave:        "5975d2fb0097c3a4b10ce6a8c84b207020108361800c86a727e0f0d4d599582b"
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
