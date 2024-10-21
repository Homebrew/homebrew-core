class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.5.9.tar.gz"
  sha256 "cf7c076cfb376e284cf81be1f30657ffeb0168ae37170552f4e7b4f6b8c155e3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a998dac4245a434be64d97da9b9e2f593b3a4dcd1e5c9bdb2e3c48de84f3c56c"
    sha256 arm64_sonoma:  "faa36cc0298123337ed4aba2049a3a1d10b0c583f93a101e427ed69b54602aae"
    sha256 arm64_ventura: "7ab6e8b319fd1c7a8e6cad1a9a8c11a71aa14630ed220833495e0f60328a49bf"
    sha256 sonoma:        "5027c4fa8aca9a6cfa7b5925e09dec2c105cb2e05560cc929f671bf2eb95fb2a"
    sha256 ventura:       "746165fcf4d74261fadcc3d2936ca6a895a6a6f3a4b66bee7cf94ce34f6ad315"
    sha256 x86_64_linux:  "40cc120d3fe014d3a9bf1d4c085d45a145407b62037f746cbfe2278abe3b5765"
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
