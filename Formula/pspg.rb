class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.3.tar.gz"
  sha256 "432ab663c0d0fd0bc28d8f5ea0f663a41ac10520cee10eb4eca2fffb74a273d6"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "551422be0f26c89abb33cce840e6321bbac292349e55f7904c8f92257776b7cf"
    sha256 cellar: :any,                 big_sur:       "2e373ec2dee2e31b451e00342adf07d5443dd9b81d0d18767045d2804a9a3614"
    sha256 cellar: :any,                 catalina:      "c204de35427b98e87b7b3d995c6b5eab114291fdeb8b05dc46859aef15babc4c"
    sha256 cellar: :any,                 mojave:        "ef34c537e5d006dc1b3b3eb8f0da51aab1a13c46cc9b9e9fd0e4402988b166f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a304babd2f3713aeb1bbe44e7fb9ce5eb01bc50615c8c5297f1980742490a3d"
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
