class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.8.tar.gz"
  sha256 "d86edea6cc84ae6fbbf2572d1711f65db5fd0166b272a483ec2829d4921713cd"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b94c83b8974a7dbdae76c53b5acf7eb2d9dd918f3d880dca72dc3d0d765fdb6e"
    sha256 arm64_sonoma:  "7d10882f789ae8d5f11977561ef5e09e2c3586398f7f52558bb4fb9bb9df986e"
    sha256 arm64_ventura: "838c293e826323237ddad9f7506e3f34b683c530be8c0d9d07d6c8217f738b81"
    sha256 sonoma:        "bdc0e3fda2c523e6929df18fee5d0a2d4b377b9d8941b07017d2cc4cc8f2e64d"
    sha256 ventura:       "ad00543c0b0de9796ae720521a6f5062bd4237a0030f9cb799b2fce26e62d97a"
    sha256 x86_64_linux:  "a6f510cd794c0b07d78f819d5adb34f13fecbd0b180f92ae1231875cfbcad8f9"
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
