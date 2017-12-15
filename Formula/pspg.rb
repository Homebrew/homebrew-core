class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.8.0.tar.gz"
  sha256 "b479164aa25b30863b410a6051638cf772c3bc00e34a695abeb43c1bb7c6afd3"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "12dfc917a5dc3eb9c5fde2925978960c572c2972f174740669ad32a1c89ec221" => :high_sierra
    sha256 "54cc6869c1972cc8737d6fcac1d646c6581358d45ced9c26b69ab35ef9a3e916" => :sierra
    sha256 "6381702e9cf175d0e185f32f81a582031af08f087bff199caf8662b0f69efac5" => :el_capitan
  end

  depends_on "ncurses"

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
