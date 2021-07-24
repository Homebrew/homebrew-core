class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.1.3.tar.gz"
  sha256 "df53ab6e7fa47d32ff2bad89d012ed610336c4586f3ffe417134c8d6af3fb9b7"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "66cc5e797aeb0c7c4fa660b86eb6abb5697334d8d90b7400318d08df9eeec354"
    sha256 cellar: :any,                 big_sur:       "a4ea2ac806a5a9edcc1a9913440c0ffdef74c6e73aeefa87c06186445fa5c843"
    sha256 cellar: :any,                 catalina:      "26b66e17fa47c6f60771a19af1e276461b4019eb556067bdce12d8b1e00ba9ad"
    sha256 cellar: :any,                 mojave:        "4c12af31b3009a098de71235ff1f8896dd62cefdde34f1891097ecb2acd8f853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0885bbcd6ee24a753ebe3f9d8c04b04b2dcc938bd51e3dfc61992371e4c8c367"
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
