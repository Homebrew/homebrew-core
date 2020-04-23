class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.0.6.tar.gz"
  sha256 "80e78bb7dca920e5940ddc24450514a50e01be0015e3d7aa8b650270e68c2fb1"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "d9faee23e0815432473ad36d782f1d0016adcede281f020f255d5246cd179973" => :catalina
    sha256 "fbbb6adbc44e70f3a2b647a4dd5254e4eaf84892bb8cb1d164b2e4106328fe02" => :mojave
    sha256 "51537e31679c0c94c567664af428debe42add8890152f897edc38fe6021c57e0" => :high_sierra
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
