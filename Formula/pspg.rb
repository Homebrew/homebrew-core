class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.2.tar.gz"
  sha256 "84b2f75fdd02598e467c56a3a7de1791aec37bbcb07da8c91a62be1cb8b7aadd"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d962e16f92f2065a90760bd10b0c10ad1d94e8866afa740f561630d17c5661e"
    sha256 cellar: :any,                 arm64_monterey: "f9c36d9dc4d71e3019c7467d7677615316dce16b3b42109908269f313234ad95"
    sha256 cellar: :any,                 arm64_big_sur:  "f8213e1422918de9ab5dbd8645bbb516ccd098c5e0ea6651dd1f146f021a6ff9"
    sha256 cellar: :any,                 ventura:        "837fec3a88a850264ffe448ef3ce61c5b7c3f2e7db6592e83de37b040b6d9d5f"
    sha256 cellar: :any,                 monterey:       "5b775ac1e710fdb44406730f1244c6b4aaaa165d39818569856e28c4108567d2"
    sha256 cellar: :any,                 big_sur:        "0cf6474b4b264b99feca3917c1effbc61b243b61f15ff680bf92371742471df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5404c99b89e747f9fa1fc7f33c7a54cf48c05c289bf2d2597f8d7ade268bb7f4"
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
