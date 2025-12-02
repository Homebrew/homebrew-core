class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.35.0/liblouis-3.35.0.tar.gz"
  sha256 "f56b21029fe7bea4ec97bdbcfa430e7e8759fccb30ea1f8e1be13c386f5b64c7"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "838726d93e12c94befd95691077df4bc65b27c46612090d0d78f2ee3a7132b4e"
    sha256 arm64_sequoia: "87fa87da2c962d2d9c42e03c417ca564b789070fddb04a06d7a0eef7c0679528"
    sha256 arm64_sonoma:  "77126ddcfa16cf7996090c2c3b6ea0afa2c871421a010f242e14a3495ad2c218"
    sha256 sonoma:        "ec16ba19c6888e32f3e14859de0528c5a158591d1aa79f12745131dc6e393993"
    sha256 arm64_linux:   "b0bfd145455a787f748acf88755a1d9a72f6d30ee6b666dea77a7774d8274fdf"
    sha256 x86_64_linux:  "a7858ece9a19c26000c6944a20d1c3fc0fb3f2166f71dee4aaddddb7fce6ebc4"
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
