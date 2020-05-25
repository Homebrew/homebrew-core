class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.1.tar.gz"
  sha256 "891d4dcfe4e911c9666d76781f5c55b33d47e9398a44a24eaac6b03b4e6ebb05"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "8277e8401d2d41cd1766e10ca2165c6c2f636e422861267a1f7bb26efaa996e1" => :catalina
    sha256 "bae0d9f32744919fdd76d447aa275d643d4271dd2a2c19e607571cce811929af" => :mojave
    sha256 "0c001fc331c10504a0ea5c475013eb650bc00a38d3f1cd42faffe47c623d740f" => :high_sierra
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
