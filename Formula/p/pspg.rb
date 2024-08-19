class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.6.tar.gz"
  sha256 "ed7c1d43c813b2415d5ce0099ae34381c10f82f211de10a4d8ed0ffcf4f2a938"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4351375f0fce202cea717331d3a12fc0910267967e9e4d30e5e2f2da62524d0c"
    sha256 cellar: :any,                 arm64_ventura:  "c39a47f68739022f17a1debad4a47c031a7759bcd477a3e729199a2809efcc06"
    sha256 cellar: :any,                 arm64_monterey: "09283444adc192dd9ee08dac08a90e86b6a6f891f303f6212da6c690ef2be49d"
    sha256 cellar: :any,                 sonoma:         "91051c3a305020451a22676e92e64f58dc95e5a940def7f5cb5b3c80187893cb"
    sha256 cellar: :any,                 ventura:        "127ac58b81dfda2c0dbccd302b4e63b77e616a3b3cf017a2ff3df2d05f154275"
    sha256 cellar: :any,                 monterey:       "9550d859de103cd5e6e334e09ff1387b2436e11d8c654cf62a7bca7cb63cba69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f263cbb1c75fe1b0fc0c02e170f95af535b1011584f7dc405c23008e41e7842"
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
