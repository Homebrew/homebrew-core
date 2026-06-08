class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.38.0/liblouis-3.38.0.tar.gz"
  sha256 "afb26096b18b17f43e6055e6a79ce0058eb9dbdcdcc4597522dcd7f11915ec16"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_tahoe:   "c68bc94eead7c994a12be9300c920f5ee99ec3c755c015f6ea10bf8719bd2f92"
    sha256 arm64_sequoia: "b82a0b0308388c5af0a1899059f405c9426e672a0d3fc70851acd02a1117aa01"
    sha256 arm64_sonoma:  "9d4182b4503152b81528ff68a417310489e5f13ac8a2cc0dea27e6faafb42994"
    sha256 sonoma:        "50c4d6f0324e25f0850f707703f78986840768321b3f9ad573c487976b0ad0b2"
    sha256 arm64_linux:   "928a6277bb82608e0be087cd57577a0906ad6b197fc2a64b3e7640924b6582e3"
    sha256 x86_64_linux:  "d8c0eb6eb533a4e49b0693653ad683274c3f4bcd4fb994446ddcb7f45304af6c"
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
