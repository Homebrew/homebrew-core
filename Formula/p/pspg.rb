class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.4.tar.gz"
  sha256 "64e25d5ae42a84d6e19985002b2006cc553e9d1a3a083edd8ab77be6c657a1ea"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "685c70b9d747b7c18618613d462ad69135c61469ffbd63fedb0e88997cb5d286"
    sha256 cellar: :any,                 arm64_ventura:  "833e1932221a58cf99e1cb5d5eb38a67e0f11ce34bb6e134ab5b68b2f4c855e1"
    sha256 cellar: :any,                 arm64_monterey: "6891aa83048d0cc3b30567258394148ddab33eeed571d72e8c08c9d5659dccf3"
    sha256 cellar: :any,                 sonoma:         "ac99399ef2cf800911e7397bd501e96876782db28653f7f50b10284161ff805c"
    sha256 cellar: :any,                 ventura:        "e7721faa3d99fa05eda796483fe7f95dcf78b14557f7946d1b9fcf4f2fa405e3"
    sha256 cellar: :any,                 monterey:       "4cf847052819acb53ee839cf520162717348f8c8edc5c06edad26ec08ede1055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23dc67f7251847bc5f273310df45cae3229721781514746289689f9ba86ebc44"
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
