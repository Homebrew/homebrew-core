class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.3.tar.gz"
  sha256 "660c338c1bf9db123073c7403cc21aa465795a9377754162cbbf8bda97259612"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2fd40b6157f3bc6722cb7f69fb6cb255ffcdabe1c617bddf6ea00da1cf2682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc005b9d89e967b0226bd188b454c93674701210b72803542f1eb050cc8dccb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3825f4dcf4006f87fe8b415fc730ac3eb6f06e0d2f56cb28b6b927acc71f4cc"
    sha256                               ventura:        "6701b85c7ed51df62a53e51bb121e31aea7ab64a284a17036e18df537c73c883"
    sha256                               monterey:       "bbb6a6834d403ef37177bfeaf79897965f344931cfda234adb54f05aef234a96"
    sha256                               big_sur:        "f4ae94895bd0907e9e85f1550b689a321b1219cadef38a63902f46acc3fa394d"
    sha256                               x86_64_linux:   "70601fae3c5ce2e041243f80403b27a592df2cda4045c98b570199295736b9d0"
  end

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
