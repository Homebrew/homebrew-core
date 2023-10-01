class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.27.0/liblouis-3.27.0.tar.gz"
  sha256 "b3f1526f28612ee0297472100e3d825fcb333326c385f794f5a9072b8c29615d"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sonoma:   "b8bc2f5b10cc8bb418fa034b81ed0d837cc3e55472f6076a20c774c50e5732ef"
    sha256 arm64_ventura:  "bd240e5b397f040b30aa68f514c1e8deee14959a5b06a9360f87e1873ab25e67"
    sha256 arm64_monterey: "0060690874f38c4d04e853552d882591ef2d5310581ad03831e71d642f2f05a3"
    sha256 arm64_big_sur:  "4f04d92c24beec33b12a966468ab01fc8de410a751987e0487cca9e4d167d022"
    sha256 sonoma:         "f74ee56feddde5772c978bea32d9f857cae308ee39014a8dd4b333b201ddb138"
    sha256 ventura:        "9876886d488f59a8267f6e24624c36e946f6d6260fe967429bf649ad0295274a"
    sha256 monterey:       "64129789d3d26cb99f874e2ff843aa2bae7ff9343c8270517a0e98126238553b"
    sha256 big_sur:        "ea73a854ace1c3f1c88e5189634983da9df8e8d81d0686ba1303206406bae085"
    sha256 x86_64_linux:   "2aa0d2c13df07bad053701a984127635321fe00a55a841bfe6cf010845c83485"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args, "./python"
    (prefix/"tools").install bin/"lou_maketable", bin/"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}/lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath/"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end
