class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.26.0/liblouis-3.26.0.tar.gz"
  sha256 "ca9446c57fbce16a856f99a1abf69ae2e8671d4d8ab44cfb353bb651a820b73e"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_ventura:  "8e27ca6da922c6ff1ea36af27d9d8a0a24d7d5f00b9743da9b9547dac8117ed2"
    sha256 arm64_monterey: "4dcc704a4b92219200e4a3ae2b324a9f22c8da9bab4531afb3b20d1ef26914f8"
    sha256 arm64_big_sur:  "53b9468532da8a619b1b9c85e20d6a8c134af1429e5209756c6ff1d6abd142a5"
    sha256 ventura:        "8e8641750034e91abbbb806b7f6724cf15a0a15d9e0fe4dfa6d256d45b97d894"
    sha256 monterey:       "fb0bfdfda6bb39d3d89c66109510a5f9bbb31acc26e5e0fedb29de72c8f605c0"
    sha256 big_sur:        "cac423a01faa175a39b03f678da7c07d4cbc3846b08bb4ad6ef34d31410af600"
    sha256 x86_64_linux:   "6bc0e47d9ef9a869f7a4cdbcc32efe997f927c2171fda117ef3e9865a51be857"
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
