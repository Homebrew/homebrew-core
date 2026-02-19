class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.10.10.tar.gz"
  sha256 "22356f526fa38f8de65f0697c9cf32f668d0cc68cd6c5529a3c1f93be8c39803"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ff0b2c77b713d8fe8fa803cfe741d35e41f5b7947b3d636e23d5fdc63e8cdc4b"
    sha256 arm64_sequoia: "7989fad2f04ce8d7a7a2ddfe7c44732022adc28ae69b66d7539e1dd922ccb68a"
    sha256 arm64_sonoma:  "c7bbd546623d7926de15c8e11479ccdb264d48158fc7307298d0e30fcc58e267"
    sha256 sonoma:        "5443d8d2d0fb35703c429a531eef2bc33f4f7d4d8bf7854c888b70b839b512ed"
    sha256 arm64_linux:   "3da2193743b2535b775840653a0824b92c32da91e52ccacfaf962425eb6fc0ea"
    sha256 x86_64_linux:  "5084bce21aad0d544e42477e3ae51f4dbb6b58ea522f1fa1f06db6c6c46ec1b0"
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
