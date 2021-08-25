class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.4.tar.gz"
  sha256 "598c672d955b4f9ae6ddfe638b2f2604830525b4d871f0ff360a451ff7af4fda"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1300e45afdc2c3463a9b500e66a46e6294c6a7d03619b36abe04bcb12212efc5"
    sha256 cellar: :any,                 big_sur:       "3d43fa8aa638c1e4250b96099193d891e4e78d424765e289b12c25d529e73fb6"
    sha256 cellar: :any,                 catalina:      "47ae8a25ac576705f7222ff4bee35ae9a077ebb1905b95a7b9e79545f3eca432"
    sha256 cellar: :any,                 mojave:        "f2ec18b523f1356cf6393621ed1d78ae34baac9d7017e73b56b047f2c91349c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90648d5627fb4bfb2c11cdecb4b60b62bbe0a128df2a8671c2585854b4b18c3e"
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
