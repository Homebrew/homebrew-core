class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.34.0/liblouis-3.34.0.tar.gz"
  sha256 "f0bf140a44f0a27d5fe9d59df79b02301f3c513b8f3eeb009d52ee4f59be0f8f"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sequoia: "c8314c903ed2d21f4e233ad66a22781c31993768dda34e63ee3564aacb033fb4"
    sha256 arm64_sonoma:  "d69585f6d5dd262ed68aeebd252d49111c058a811f11ebd85de0f09d23fe5c82"
    sha256 arm64_ventura: "ac22eefa58b99225d467a1f98d53f1c0441659f0bba494876999bf35f206611f"
    sha256 sonoma:        "95c9534295806a8d3bd1d293125836945f29df4d8b39405ab704c496cf38425c"
    sha256 ventura:       "97187c91e88255175c59ac3727c4ab42f2aa1f947d67f76f2f85816db26fdc89"
    sha256 arm64_linux:   "266d36fc10e4a92b37ae7b963a025adda1e30e13dcda98bff5943d22bfb1a7b0"
    sha256 x86_64_linux:  "ae52aaf5548ea1787bef2c53825d01fa68853beec7482d00150a72145289f3d4"
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
