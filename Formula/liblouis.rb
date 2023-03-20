class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.25.0/liblouis-3.25.0.tar.gz"
  sha256 "d720aa5fcd51de925a28ae801b8b2ca76ee67e2360b40055c679bce8e565f251"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_ventura:  "36e06c5b4c45e094930c74ed0dd7417904c5a2ad9b13b4feb5c21dae080cb30d"
    sha256 arm64_monterey: "db0c598e3055d9e336a4e16a9c32008eb2a51fb0fb215e815707485149b523e3"
    sha256 arm64_big_sur:  "f67d596cfef6af2b942e249059b5c4e936bbea07309d6eab4bc83eefbca67f9f"
    sha256 ventura:        "dea5a8bf57f5c06477d22c2bcda00a40bfc4a0854c870f8f693e0fb11c0d135c"
    sha256 monterey:       "06f77e43c65ac4d1bbc0645777b30e16099b3ad22328c6f79e532a6d3231f70a"
    sha256 big_sur:        "86a01b4d981ac94347f98ca5d5a3a656f5fa2b41b62fb2ab2a024516446fa316"
    sha256 x86_64_linux:   "b28e4eeea41196e9ae15afec159d94fde1e271296b48570de3b850a73d13b2b7"
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
    cd "python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
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
