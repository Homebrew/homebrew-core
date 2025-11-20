class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.6.tar.gz"
  sha256 "505b41bd7009bc86207f6da7942b36c030d3a79d58307c8fc716c211fc077a23"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dd7a64c548c641f6f3cd370e7ff5aa84fc3992b40613a6228633c003743db900"
    sha256 arm64_sequoia: "d3945d3f5c67b6082da3775d52bf06c6235967da912d3bc05f9b78d605f1e813"
    sha256 arm64_sonoma:  "64face77379f3a69810fe224a265b04fb167ec103f36e44215b68e2cce0184e1"
    sha256 sonoma:        "5a3be05b8563ba43ccae4fbf82e6de5b37ef495c02c7176d719cf8033b71cfaa"
    sha256 arm64_linux:   "29a0ffb1632f2c174389477b2db6d77a951cd4783c3f51665d8ad94ad2042a92"
    sha256 x86_64_linux:  "f7625f4570c9276437587323653034e8c39ff66503abb535b1298f05bc8b4842"
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
