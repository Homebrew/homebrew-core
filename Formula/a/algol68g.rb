class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.0.tar.gz"
  sha256 "0e5358db0a7694013da0b48c5d74e95a9f8efc02e02ee7d4f7d9da9d99ae2cfc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "505b6192280706a929eb0fe6e31d99c269aeb23888bba4060ef391cfc0b52464"
    sha256 arm64_sonoma:  "9999259b1c907c400b2123072154ac6305a1969f016bd0b3de590bac2e5581fa"
    sha256 arm64_ventura: "ed776f2b265491ae17cc4e0a50d3c1682c4bdb64a369a397c9779a482c750aec"
    sha256 sonoma:        "3721a00af9146dfb9b393167887663ca5277d85c88583f69c18799b20d00293e"
    sha256 ventura:       "9922b9ec19c6b57e088de33bb5435956ce56261d543d673b79832407690af70b"
    sha256 arm64_linux:   "178fb9ff29087a99bee1c1d1962a907569042aa84320b71d2e4e464534a86568"
    sha256 x86_64_linux:  "7daf44163e87a0cd899e190d4747f7bcbedc18a5091fd6b32ee916f787944351"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
