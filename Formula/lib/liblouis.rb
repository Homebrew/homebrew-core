class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.39.0/liblouis-3.39.0.tar.gz"
  sha256 "629fa8cb0dfd9ad457c5bf47a42f0953b673e62c8ad6b1d03ddc4e2bd20008f1"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_golden_gate: "3f976411273e42c02eef532475d052516139cd4b35a4a3f07ec61cc4c167a804"
    sha256 arm64_tahoe:       "b99fbc2a714f4bf4ae6134c435b32c97fdea1627b05d5082ac4f9d6dbbb59f34"
    sha256 arm64_sequoia:     "da450da46bcdb7204c6e676040ce131693b0b3be5511d7a3d32e0a276b81e24d"
    sha256 arm64_sonoma:      "61b92d0ffac7be262e53a384cb860dea7b9a74e6694d58f840a70d4675fa57f7"
    sha256 arm64_linux:       "33b61832c6af5ddd32ebc59c0fba8d8dc9fce9cf6908e4640aa258820af4f11c"
    sha256 x86_64_linux:      "7585b2fa29646e82af2a0e3b2e31e52aefab31f74b7ff333c508c5a47e32de74"
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
