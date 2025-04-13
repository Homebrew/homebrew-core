class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.33.0/liblouis-3.33.0.tar.gz"
  sha256 "e2ad56d132d0cd63f08f3122391a0472adcc8c5d046d7cd81bcadf48a55deea4"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sequoia: "50f37b5fbdceca05fa294a6029c04b4b182b43718ffe353c300663bbc8c72632"
    sha256 arm64_sonoma:  "c9f967c7b2d9b6b4b0f3642a9a31142092b2b9bd4d1293cfb56a983eabade6b7"
    sha256 arm64_ventura: "76c0a6395652160429e77a41318c995211edc60918942999783526a624297a6d"
    sha256 sonoma:        "c658092622f42c094e13ed9bb243ff9db4b931e3ba8ccf574b8dbb10b70b488a"
    sha256 ventura:       "3b5486f4d87050ece459d29c197043ab55ca96f39ff9019ecedd7d531481a2c0"
    sha256 arm64_linux:   "1a1b60e4245ffd2b5566d0b9c98d224e5f861c2fd2557904b9924288fe45714f"
    sha256 x86_64_linux:  "cea6123b5927e70704757008f1314af7e0bf73cc83cc2d8fdd01b817036df110"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13"

  uses_from_macos "m4"

  def python3
    "python3.13"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python"
    (prefix/"tools").install bin/"lou_maketable", bin/"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}/lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath/"test.py").write <<~PYTHON
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    PYTHON
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end
