class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.0.1.tar.gz"
  sha256 "9dc539b4acde5a11adc90a2017dd9a26fd32636fc1109c49dfdf4283e224144b"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "9adbd0ee774f38ab3f8685dec3644631746c4c8e440f77312a6364f0491298b3" => :mojave
    sha256 "2fc73bcc40965c4ec4ab3fc71c9f2fe8f1b245d4998b0d1daa154490354c96fb" => :high_sierra
    sha256 "cef9adb34ab1d0e0618eb8a1b0d1a155372ea988bcd2608b1888126eb5414a07" => :sierra
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
