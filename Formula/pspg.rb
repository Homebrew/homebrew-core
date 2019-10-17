class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.8.tar.gz"
  sha256 "13c1c96b3f4042fb1ace4f9a2ff8792044adc4dbbe60e9298280a52387bba78e"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "ad1e44f87cd893dcaeab0dda9df3d4f294d18ce39c66d1c001b75461e4cf22df" => :catalina
    sha256 "ce0b0e03d07fa3f382049e92c13f533a3bd5f12daa19edd8e6396f2402933b64" => :mojave
    sha256 "3fe9db926e8e5b1bc0edb39d80672f487490e542f5a0426f6c25e9b91dd63837" => :high_sierra
  end

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
