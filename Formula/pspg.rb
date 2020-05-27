class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.1.tar.gz"
  sha256 "891d4dcfe4e911c9666d76781f5c55b33d47e9398a44a24eaac6b03b4e6ebb05"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "4b183ddbc4df665c3b20196584bfbb4e6c9b555301c85386aa43f318c291ac85" => :catalina
    sha256 "617c45fca5eb99539594754a44ecbb2abfdee5fd40a87a275d25ee7f1a79a846" => :mojave
    sha256 "fc598421ba21cb6db546045eec0be613235f244f3eff6f8e5188c593959b96f0" => :high_sierra
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
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version", 1)
  end
end
