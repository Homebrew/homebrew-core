class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.7.tar.gz"
  sha256 "b447698d7c2c409a23cbd9fa3f6668ec982ee7769438aab564813f548666ebd6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b7784da01b753467614f8e9f3fed8211407525d0ac703b3718fabbc2cc36ee0a"
    sha256 arm64_sequoia: "e634e7ed4d1397e99ff54538a4dfcd77c7bb5f065b30f072785ec51aa1abc0da"
    sha256 arm64_sonoma:  "55de38ea0df51a110e01832ff7d344fe8976bef167ce2a33ba801693090dfa23"
    sha256 sonoma:        "ad67243d563b8e16f96e18b2025c1bd18adda20d37cd44ee655b1b80f72a2ce0"
    sha256 arm64_linux:   "70157beb84177a51556a272ab009e34597f4557f598c6a69595c7682eeb4e1e0"
    sha256 x86_64_linux:  "b1d40ce088e0f03c175da553bf776b113e5d4bf539b9ef77e9ca18bebfe57fa8"
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
