class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.8.tgz"
  sha256 "3eb30d1051d8b48999fe46511c9f6983057735312c9832b7db13f9db140db74b"

  bottle do
    sha256 "fec8c41780f5f89c39e772acc479816e95b29e7a2d0720a175339c1402d7d6a1" => :mojave
    sha256 "602e9ee61ab977a245282184c1148d1bbbbd74b8298ece34a55143888299c0db" => :high_sierra
    sha256 "50f5e28b01a2c73be91a0bd64a5069d0965901544186d41150b94ec736b1eadd" => :sierra
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
