class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.39.0/liblouis-3.39.0.tar.gz"
  sha256 "629fa8cb0dfd9ad457c5bf47a42f0953b673e62c8ad6b1d03ddc4e2bd20008f1"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "60cadae9a7434f9cb7887560efd19cb44a70b8157aed040dcb813d811ce8386f"
    sha256 arm64_tahoe:       "56e4f4d314661bce75bc35213f0d3ec49e0f30ba998a604f64d74217b7a3b002"
    sha256 arm64_sequoia:     "f6ae9d39f4433af8607ebdda1456d64c0a0bd9927ba5a3640fff8792531748d3"
    sha256 arm64_linux:       "57e4b7d9ae8c310fee99a4527f5abc874ee4e2b57b9ceed9af449332c8abbabb"
    sha256 x86_64_linux:      "582a2367509a834b7fd6dffb9394e3183b5e09638bdba54b218cc39f26eed0f0"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15"

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
