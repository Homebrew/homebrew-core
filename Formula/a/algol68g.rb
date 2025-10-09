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
    sha256 arm64_tahoe:   "cfde43cb8b8331718ae00931787ba629618da3c95b3e37103c72bc7dd3da8501"
    sha256 arm64_sequoia: "798a6128c3ff3220332ec4a280870cd8f8b08e4a51b5fbef6425844ba052708a"
    sha256 arm64_sonoma:  "455b9dc92c67c86c6650fe015659a8edb67b72303417b6d656bfe28416687d88"
    sha256 sonoma:        "dbc808e5ed996cd3813cbdd1f85261197d0696c8b4d5584adaa08c651fef8d4e"
    sha256 arm64_linux:   "73b13bd8b04ed5bd22750f1a2e02490adb5b1cb165d70852f27c5e0c63b0a2f7"
    sha256 x86_64_linux:  "1e7478e39a4c17807b38c5afb121dfac73333a110aafd97913dc736da1bedbbd"
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
