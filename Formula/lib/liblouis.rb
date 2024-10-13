class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.31.0/liblouis-3.31.0.tar.gz"
  sha256 "29286fe9edc9c7119941b0c847aa9587021f0e53f5623aa03ddfd5e285783af5"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "3334c91de4d4c79dd3c147e4bdb780dee0f111e2f0397645e44afe81684876ac"
    sha256 arm64_sonoma:  "72fed129c3125d2898ac2471dd9aaf9ee88654c5da378127f13c14094483b921"
    sha256 arm64_ventura: "bbe0152d21f0279017c7797f50943d67b75039ffc5ef99869385ff39526bd2e8"
    sha256 sonoma:        "e55bf69d66314d7f3f56cc5fdd581dafdd5f9813f2fe80320dce7149b21fb099"
    sha256 ventura:       "bcaccad9720ffdeb02583186c47cac4f5fa3cfdf2390b418e9ce7efc4427187f"
    sha256 x86_64_linux:  "f2b089b561c43addb993a89897b184c7db5b296e13f86957f987db484a583215"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
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

    (testpath/"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end
