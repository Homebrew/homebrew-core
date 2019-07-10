class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.8.tgz"
  sha256 "3eb30d1051d8b48999fe46511c9f6983057735312c9832b7db13f9db140db74b"

  bottle do
    sha256 "c04f0c743c998cd8c63483c9f4d47311e9df465144390dc8d6db266499f9aaf5" => :mojave
    sha256 "7aa642136a7d5be56e21b2ffa424d0f0dbf09f1f4789733f2fd73bb551212ace" => :high_sierra
    sha256 "9aa6541d4840bfcb1c5b62a4f66c2c9a071cbeb03d7913798dc6e86261ea29f6" => :sierra
  end

  # Fix build on macOS (and other libressl-based systems).
  # https://github.com/shirok/Gauche/pull/483
  patch do
    url "https://github.com/shirok/Gauche/commit/891f40ae195565de803c2aaf2db27db0e11300a0.diff?full_index=1"
    sha256 "0bbbf0bb24ba4a88a8c4895632a59f75a89c8306d58a8877c3de536cfa926f8e"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
