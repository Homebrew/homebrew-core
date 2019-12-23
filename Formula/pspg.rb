class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.6.4.tar.gz"
  sha256 "2d2b14a87056ce09625298de22629866c3c14aa55d46ea7ee627a682b9ea804e"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "9a4790e9a52ebc240b126bfffffb5de551af189ae3b70556976b47fe82a83111" => :catalina
    sha256 "1ec39b50bd344692740069f60f009fa8b6a4d032c7298db4d2f2168435e0fbd4" => :mojave
    sha256 "80ebbbf3457b508426cab75935129a36b979edbca03f5e5e2aaa3f98ae854146" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
