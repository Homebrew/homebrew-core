class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.6.3.tar.gz"
  sha256 "5330a26a928101fdcaff94ff17f14b3c8a79ed9d433ead73785d99c9be7b847a"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f4f5fc08e84526e771b4dfe62e4af161a19d0b500142446b057fb6a49a4aa6e"
    sha256 cellar: :any, big_sur:       "1e7eb4d317337154f25e411dcf2ebbfe0fb25e144b3c6b52b38a7ef3d69704b8"
    sha256 cellar: :any, catalina:      "e8a35b1103a2ab30378645e7a5024b5abb0c551b20e0b76d9aa221e13d995bfd"
    sha256 cellar: :any, mojave:        "3d84a23a336e76a3027b87e497f7a4a174e61bfc84e219dfdd9b6bba83d60ef4"
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
