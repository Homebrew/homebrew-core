class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-3.9.10.tar.gz"
  sha256 "29f4b7c392b04c7b5f9191a4647ea222856f95d79a6756c52c0bd93c70bb94a8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://jmvdveer.home.xs4all.nl/en.download.algol-68-genie-current.html"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3bfd36be17c14781fd5170d90af7fcbb593b5386e579e7304d5478af2ed61697"
    sha256 arm64_sequoia: "65139ce484d98e1ef910b0dc5598eb1424ac20f107aa595ec13713c775b4c016"
    sha256 arm64_sonoma:  "77f0d76fa86f033082dff42ed2b755cf54320f315a9ab6ff69292816ccf009a4"
    sha256 sonoma:        "f3ac3894d6d76f1bfa99fd24648f9955b748fe297567bd993652c9dd1fa63c7b"
    sha256 arm64_linux:   "c65276e09e3f3d5cf5d0db153df5d831af79577968c915907a3b49524abd6eaf"
    sha256 x86_64_linux:  "57d137468888a23d5124e29d09638d0da6d0efa7035cc325a994db17d6e0bd02"
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
