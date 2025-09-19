class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.5.tar.gz"
  sha256 "10a07ec0f47e42367a1411f9ce309e13e4b7bee66bb5c218b212ff023bdaa39b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "61cd0c861fb494b26c58ed31f3a320ae52bb210a4b5270f3699d74b8954036af"
    sha256 arm64_sequoia: "b151d5604058bd8a5eaf0e3d53094314eada025ce1f6ef75dc3c160dfbd8f571"
    sha256 arm64_sonoma:  "94753a83e15fd51ab269944263876b7754baaa2a9980ce39fd5d48db949764be"
    sha256 sonoma:        "5f68df41a84da531c0151c970b1f2745ccc222ec0ceebe4886ed1dadabe01951"
    sha256 arm64_linux:   "b2dd752110e12c5b377a901877d391f1094e5746878688bca37d702c5d30b3e7"
    sha256 x86_64_linux:  "21caed81dcf269a1ac889cb7e289bbe1e1a01c085d5aaf6500bd221b3b34650f"
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
