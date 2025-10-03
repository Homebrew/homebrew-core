class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.35.0/liblouis-3.35.0.tar.gz"
  sha256 "f56b21029fe7bea4ec97bdbcfa430e7e8759fccb30ea1f8e1be13c386f5b64c7"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_tahoe:   "2beb4aa4e13e8f8c04ec8194a69e360ea68658891d0721ee42b9927075aff7f1"
    sha256 arm64_sequoia: "0ebd3c2d1b22f0b7f469f2c247e04ca81b6149e7019bee5d9fa0c715f1eedc1d"
    sha256 arm64_sonoma:  "4158c38ac499a63bf9de46dc577cf5d034cb631550a116804156ea02ada00286"
    sha256 arm64_ventura: "c008222dc899f83733e6ac774d31188951536aee5543da7b5074ae3aeccf952e"
    sha256 sonoma:        "cb8fb5872f7078d707af7698122ec678bd1d65ae16f0022315834f867d193a50"
    sha256 ventura:       "bdbcf6c82ee421a758468e8e75da5303e4c27fe8fb306e79dbbc7ad666a67304"
    sha256 arm64_linux:   "cda0dc6b5f9072e18a2641e71eac5aacf824df6e8527212530f8d8c6fba1623b"
    sha256 x86_64_linux:  "1b4f29997e19ac07da608317818e2d923030a16855a2cdc018cbdd041448de8a"
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
