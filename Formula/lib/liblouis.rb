class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.37.0/liblouis-3.37.0.tar.gz"
  sha256 "6c3bd3ea73e0cf39d8bf0d724a0ac5ebcb5a24a70f21420de50c8e9f8d009a61"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_tahoe:   "a2768d123f8751d609e989c435483f8fa709540b9a633742544e7f96064ddb9c"
    sha256 arm64_sequoia: "5daba9400a4cc94878caa3e56f5b0bc623451dcf9a3ecbc2c775bc58ef29ad28"
    sha256 arm64_sonoma:  "56c20e672f7da2e92b090468932d197cbb8ee7dce9564322ac4015282ca3400f"
    sha256 sonoma:        "745ca9bc434c642dc0fcbd0c8c2053bfe74e1553d002f6ae2351ebd13aa43e0c"
    sha256 arm64_linux:   "c51538eb5f9f13cce80edc288d33d700bf3250808f2d9c3d9b94003c61d79f28"
    sha256 x86_64_linux:  "c763b2bac538c38ccc11e3c0eef7d63634020d6c8037f1d7c0683cf36c254138"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14"

  uses_from_macos "m4"

  def python3
    "python3.14"
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
