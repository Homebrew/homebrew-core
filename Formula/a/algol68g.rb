class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.3.tar.gz"
  sha256 "7df60b13778233bd925e3e447bc6eb0abf8f12c01664bb8118707ea31b938c33"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d8e44a94dba3d849953cc45b14468273d30f76d4302f0d7988f977a4c82b0ca0"
    sha256 arm64_ventura:  "44051f352ba08d81c7121cd9c17ec6d54ea075fd91051c69b50e87959d44024a"
    sha256 arm64_monterey: "745ac940b22088c1a728faa3deaefdbc8715501ebac3451069407f453351c68c"
    sha256 sonoma:         "edc1aeba7462d06e913adcda60fa859e4fe866bac6833d6ed9b04942bed62ace"
    sha256 ventura:        "4e70dc8e43a6f949f29712aa8119917e0d120fc79fef01ded226a2e8c45952b7"
    sha256 monterey:       "ff40e5ef3c61e683800d28412f475a3d8b2d6a902184d49164d0590e639b83d0"
    sha256 x86_64_linux:   "56dc007f0ae2f585c1cf62a2aec3b9828acddf2cdd92ade57992c03a958ae4f2"
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
