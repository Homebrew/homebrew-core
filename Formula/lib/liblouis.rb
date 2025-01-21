class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.32.0/liblouis-3.32.0.tar.gz"
  sha256 "645b47e2ad47c6b06f3591aec5530cc2b5596c51438c1ccf38213a9fdfe23853"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sequoia: "03734d9a845b60b2aaca63658012d800a95d3c08cff8d76e951a17121f180586"
    sha256 arm64_sonoma:  "3276f0bef29711e366c72ae5239e787f04a43120acbc7a989406b62d286951bc"
    sha256 arm64_ventura: "b87ebd264ff23a45ccaa3ffcfc402c7e4fbc50abb69489177dae8eb7971399d2"
    sha256 sonoma:        "d95e25096c63de35a52ffae8a5bebc9669b0cd6cb378ad6e063cfaddaa6b3ba2"
    sha256 ventura:       "f480db1162d43b7c9d75e4a86a23a86d211d6707e3e03d7d1ade2fcaaf0f5117"
    sha256 x86_64_linux:  "af1b479ce383564cf760c680a47440c1c6cae1f05961d57108d2fa066dec7c33"
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
