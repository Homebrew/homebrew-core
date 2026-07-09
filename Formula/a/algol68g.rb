class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.12.2.tar.gz"
  sha256 "e1f8ae6eaa60a07dd83a50a0d5b24743790e6b228dba55b70986ce2b56b013b9"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "49de8a393d2b7fa64ea6552eaa3884a45f543fb96ca9e0047f2b275d6de7670a"
    sha256 arm64_sequoia: "0344d796f01df4174d581fd868d679cd01f5e25a3a3f49c2f06f4d97bcd2a902"
    sha256 arm64_sonoma:  "b35533b9aa35fad58b94bf3e4e203cec2e6b4a92ff92af357684e9dcf579f6c9"
    sha256 sonoma:        "04b42e4128dda0bef240c105c1d42364b998369c967c24e424a03c3cdb0881a2"
    sha256 arm64_linux:   "f4d63bb20cd43798a6f976e20c23f18578e45bb6035ae783ded596fa43863c8f"
    sha256 x86_64_linux:  "9e4b71c332d5cef855419ce9f46b6b55422d8a920ddb2683eda6e8453a394aa2"
  end

  uses_from_macos "curl"
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
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
