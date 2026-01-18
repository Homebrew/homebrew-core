class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.36.0/liblouis-3.36.0.tar.gz"
  sha256 "b311903137bd0de31da1f2003997294400098c17b42ff339bf2692eb83be70d4"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_tahoe:   "d29e4836a2086bce4ca76567e8ae47a2d82b17cdfcfe2a23a31d3c94dab21cec"
    sha256 arm64_sequoia: "02188bc8368876596e9cb133409b77189a7e7a5dde58ae3c535e9379c1a9ac7e"
    sha256 arm64_sonoma:  "cc330d7eadf7fcc2d28672018bbe414631f80c3bcdaa0112594927b7984c85be"
    sha256 sonoma:        "f1ea476219643427451ea09da30d83dfe9eeaa4c1833d16c9d43440abe3614de"
    sha256 arm64_linux:   "321b2cf2cbd2ea3aec23e036a1d9a9806ad319d62a17404da96614c3c1002e61"
    sha256 x86_64_linux:  "a81162639d2dbc8af72f0af7a9457032746a58f60b400884537cdba203de6779"
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
