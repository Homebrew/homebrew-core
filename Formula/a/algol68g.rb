class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.8.1.tar.gz"
  sha256 "0a2cfe9ef4747fdcca1799432e5b5cfe62bbde1bf9adeb9916600c2a30fd3a19"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3486d2728f7d08b4a9c19d61582adedcb78fec417bf401d7bafb738502d571aa"
    sha256 arm64_sonoma:  "f9118fde5470f02b5a416a4574dd5d5cb6be85661762740c272116273b061b0c"
    sha256 arm64_ventura: "dc9d37f7f18f5777a666e9782d45641c6f02b6469ef4963e2363da31ff2d384e"
    sha256 sonoma:        "5be8b55fba9ec3a9c9ca8d94703f8010040d1d6b491d38bc50119af9a3674422"
    sha256 ventura:       "cfb48f1b724c3b898b8583180ea6debbb568bb7d3e4ee5d073f61b69ca8c1a49"
    sha256 arm64_linux:   "819e11fa380c5e1fdf3267e31bb8caa03792310949a6445ef6bbb59866322609"
    sha256 x86_64_linux:  "b28a4dec42c41165f4f53c0ebef207beafbb3f06c631f66e0a7258694b962936"
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
