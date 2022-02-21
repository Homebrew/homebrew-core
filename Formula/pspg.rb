class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.4.tar.gz"
  sha256 "1ea5b0b8397a6ed169c6b33afbe617fe2c33820deff6395888c0c8ae2c115d30"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af6b601ae5462e37ca340e6c265694efc4c9f81b43c9c618451040d9dd8f487d"
    sha256 cellar: :any,                 arm64_big_sur:  "d067f45f518b2dc28d1186277bf58a0d13f814a96ab533249d8f06ea83db61d4"
    sha256 cellar: :any,                 monterey:       "f367861be235a8a156d191250bfa7307cf61f1c898c34a88e3f2357f251fd664"
    sha256 cellar: :any,                 big_sur:        "60f754d4cc765ac873dbeb4ece81a59983a912a90064f606a3ac63fab402ccca"
    sha256 cellar: :any,                 catalina:       "0da663231dea4165fabd3a39995adc3af4230c073d75875e3b9df8e716be8d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8152d13a23d3c931a362fac37043a2b2072b26ba42729d9972ccdd88d8609a"
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
