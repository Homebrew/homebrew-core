class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.7.tgz"
  sha256 "2d33bd942e3fc2f2dcc8e5217c9130c885a0fd1cb11a1856e619a83a23f336a0"

  bottle do
    sha256 "c04f0c743c998cd8c63483c9f4d47311e9df465144390dc8d6db266499f9aaf5" => :mojave
    sha256 "7aa642136a7d5be56e21b2ffa424d0f0dbf09f1f4789733f2fd73bb551212ace" => :high_sierra
    sha256 "9aa6541d4840bfcb1c5b62a4f66c2c9a071cbeb03d7913798dc6e86261ea29f6" => :sierra
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
