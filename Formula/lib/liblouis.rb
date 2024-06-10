class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.30.0/liblouis-3.30.0.tar.gz"
  sha256 "37328e938a6b432e2700156ed76626b04b06ae296a6da179e0cd64b547ef29dd"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sonoma:   "330b924949add94fa528ec3e4ed79050fb76a8141dc938fe3ec3f49c06df72f2"
    sha256 arm64_ventura:  "f53a60d37f71445867dac720aa0aedaac3db5b8cddf89d01acc3359bdd0d3f77"
    sha256 arm64_monterey: "79d26ec533d715dd5bc28ea2cef36a8f8809ae57ce79f41b5616dbf1b0b5b824"
    sha256 sonoma:         "30375749b231d4d1e3aacb24935bf418ac371ac539e2e7b56fb4201b045dfcd7"
    sha256 ventura:        "77ef1d9bed5f43b5154322d565ef935c4db6603f48113844448a1f7ad0247fb6"
    sha256 monterey:       "a58fa76c30754611856fe7e127796d3d61443d70cee802f9353d7b90aae313bf"
    sha256 x86_64_linux:   "3c2b30a446ab75b75c3f109cf6d07c5f3ffbd314f72d58883f3777df13791b73"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"

  uses_from_macos "m4"

  def python3
    "python3.12"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./python"
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
