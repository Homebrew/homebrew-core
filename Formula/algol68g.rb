class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.1.9.tar.gz"
  sha256 "6705656c29283ae2fc34276b1e628882e66ee0b982c30c19023427d0333f10fb"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7c88a33670574b1037655110476b2f5e84df039b5f95b385986d1b3f82df9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8d3605623805841721590b578f54bc37f5dad2340c0461dd957bb51b2d9a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10e338e9fc88fa84893605c3ecdec7f6dfd71559b130716e7900adea0811de8"
    sha256 cellar: :any_skip_relocation, ventura:        "6dff2f48a323d8d85eda3fc1513efe94b469d28eced8ac9618dc4ec914b14ed9"
    sha256 cellar: :any_skip_relocation, monterey:       "e6e31034dc790a2d03806e10300fabe67c5405176d6da447d665d002dd7570b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e33b5e52bac1290eac5ad02397c3391e6306c5c8fb7b4600b092b727ed41392"
    sha256                               x86_64_linux:   "6a759343024e419a055d0dc73dea4b9dcc7874638a3207af2551449359c4813c"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
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
