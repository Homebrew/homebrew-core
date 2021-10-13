class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.4.0.tar.gz"
  sha256 "6f91324851d9eab1da8d1d4661be386af3d8531ee00df0243c7d9b03361fd445"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e11f3cd3148dccae6f0c2cb596e56edcf4c36bd93fd841e40e075ac194c80747"
    sha256 cellar: :any,                 big_sur:       "b558ef761289e61476a43ad232bdd7d523cc9c3188de0d91fa6ec9f2ac886fae"
    sha256 cellar: :any,                 catalina:      "4c1be52363d5cad4503d566d62370c89174cde77ec54cfc4837a960017fadaef"
    sha256 cellar: :any,                 mojave:        "be8febc067a1aba56bd8c535314250057d8bf8d240c1d7ab1bd3de17a61753c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b69af1506c9344b179313f7673c1acd4bfcf5ee3f78cffc5308649e1443cef"
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
