class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.2.tar.gz"
  sha256 "161b3289cb511fe47fb45f7da76f70f01617735317e6696ffe35e0f018a77f9e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "530a4d047f7d28be94ec53f28e3da86e848aaa23ddf6e3e96b12d55a245a0e39"
    sha256 arm64_sequoia: "a645b4547a1b8989c84ebbb7820a3b3001586793a5568277f9fcf75ae6dd6bc2"
    sha256 arm64_sonoma:  "783e67694d758c4bb3c488512cb9870e4b546a718dabefb217483b36e7193a4f"
    sha256 sonoma:        "13c5f12bcb5a8421e0923b64dd8fa60a583add11b92c65c1da001c612dea59be"
    sha256 arm64_linux:   "277aaa03c96ec049d3e5505fb14d3c94a35c546e3aa6ac3df59753a2ef809e91"
    sha256 x86_64_linux:  "adeb6982587b98910ba21bd4951e351a6a5890f8e8286c02ec89ddee4da99981"
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
